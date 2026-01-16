#!/usr/bin/env python3
"""
ABOUTME: Robust linter hook for Claude Code that checks TypeScript and Python files
ABOUTME: Reports linting errors back to Claude Code for immediate attention
"""

import json
import sys
import subprocess
import os
from pathlib import Path

# Linter configurations for different file types
LINTERS = {
    # TypeScript/JavaScript
    ('.ts', '.tsx'): {
        'linters': [
            (['npx', 'tsc', '--noEmit', '--skipLibCheck'], 'TypeScript compiler check'),
            (['npx', 'eslint', '--format', 'json'], 'ESLint analysis')
        ],
        'formatters': [
            (['npx', 'prettier', '--check'], 'Prettier format check')
        ]
    },
    ('.js', '.jsx'): {
        'linters': [
            (['npx', 'eslint', '--format', 'json'], 'ESLint analysis')
        ],
        'formatters': [
            (['npx', 'prettier', '--check'], 'Prettier format check')
        ]
    },
    
    # Python
    ('.py',): {
        'linters': [
            (['flake8', '--format=json'], 'Flake8 style check'),
            (['mypy', '--show-error-codes', '--no-error-summary'], 'MyPy type check'),
            (['pylint', '--output-format=json'], 'Pylint analysis')
        ],
        'formatters': [
            (['black', '--check', '--diff'], 'Black format check')
        ]
    }
}

def check_tool_available(tool_cmd):
    """Check if a linting tool is available in the system"""
    try:
        subprocess.run(['which', tool_cmd[0]], 
                      check=True, capture_output=True)
        return True
    except subprocess.CalledProcessError:
        return False

def run_linter(file_path, linter_cmd, description):
    """Run a single linter and return results"""
    try:
        # Add file path to command
        cmd = linter_cmd + [file_path]
        
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        
        return {
            'tool': description,
            'success': result.returncode == 0,
            'stdout': result.stdout.strip(),
            'stderr': result.stderr.strip(),
            'returncode': result.returncode
        }
    except subprocess.TimeoutExpired:
        return {
            'tool': description,
            'success': False,
            'stdout': '',
            'stderr': f'{description} timed out after 30 seconds',
            'returncode': -1
        }
    except Exception as e:
        return {
            'tool': description,
            'success': False,
            'stdout': '',
            'stderr': f'{description} failed: {str(e)}',
            'returncode': -1
        }

def parse_linter_output(result, file_path):
    """Parse linter output into structured error messages"""
    errors = []
    
    tool = result['tool']
    
    if not result['success']:
        # Handle JSON output from tools like ESLint, flake8, pylint
        if result['stdout'] and (tool == 'ESLint analysis' or 'json' in tool.lower()):
            try:
                json_output = json.loads(result['stdout'])
                
                # ESLint format
                if isinstance(json_output, list) and len(json_output) > 0:
                    for file_result in json_output:
                        if 'messages' in file_result:
                            for msg in file_result['messages']:
                                errors.append(f"Line {msg.get('line', '?')}: {msg.get('message', 'Unknown error')} ({msg.get('ruleId', 'unknown-rule')})")
                
                # Flake8/Pylint format (varies)
                elif isinstance(json_output, dict):
                    errors.append(f"Linting issues detected in {os.path.basename(file_path)}")
                    
            except json.JSONDecodeError:
                # Fall back to plain text parsing
                if result['stderr']:
                    errors.append(f"{tool}: {result['stderr']}")
                elif result['stdout']:
                    errors.append(f"{tool}: {result['stdout']}")
        
        # Handle plain text output (MyPy, TypeScript, etc.)
        else:
            if result['stderr']:
                # Split by lines and clean up
                error_lines = [line.strip() for line in result['stderr'].split('\n') if line.strip()]
                for line in error_lines[:5]:  # Limit to first 5 errors
                    if file_path in line or any(keyword in line.lower() for keyword in ['error', 'warning']):
                        errors.append(f"{tool}: {line}")
            
            if result['stdout'] and not errors:
                stdout_lines = [line.strip() for line in result['stdout'].split('\n') if line.strip()]
                for line in stdout_lines[:3]:  # Limit output
                    errors.append(f"{tool}: {line}")
    
    return errors

def lint_file(file_path):
    """Run all applicable linters on a file and return consolidated results"""
    if not os.path.exists(file_path):
        return {"success": True, "message": "File not found for linting"}
    
    # Find applicable linters
    applicable_config = None
    for extensions, config in LINTERS.items():
        if any(file_path.endswith(ext) for ext in extensions):
            applicable_config = config
            break
    
    if not applicable_config:
        return {"success": True, "message": "No linters configured for this file type"}
    
    all_errors = []
    linters_run = 0
    
    # Run linters
    for linter_cmd, description in applicable_config.get('linters', []):
        if check_tool_available(linter_cmd):
            result = run_linter(file_path, linter_cmd, description)
            linters_run += 1
            
            if not result['success']:
                errors = parse_linter_output(result, file_path)
                all_errors.extend(errors)
    
    # Run formatters
    for formatter_cmd, description in applicable_config.get('formatters', []):
        if check_tool_available(formatter_cmd):
            result = run_linter(file_path, formatter_cmd, description)
            linters_run += 1
            
            if not result['success']:
                errors = parse_linter_output(result, file_path)
                all_errors.extend(errors)
    
    # Prepare response
    if all_errors:
        filename = os.path.basename(file_path)
        error_summary = f"🚨 LINTING ERRORS in {filename}:\n" + "\n".join(f"  • {error}" for error in all_errors[:10])
        if len(all_errors) > 10:
            error_summary += f"\n  • ... and {len(all_errors) - 10} more errors"
        
        return {
            "success": False,
            "message": error_summary,
            "error_count": len(all_errors)
        }
    elif linters_run > 0:
        return {
            "success": True,
            "message": f"✅ {os.path.basename(file_path)}: All {linters_run} linting checks passed"
        }
    else:
        return {
            "success": True,
            "message": f"⚠️ {os.path.basename(file_path)}: No linters available for this file type"
        }

def main():
    """Main entry point for the linter hook"""
    try:
        # Read tool use from stdin
        tool_use = json.load(sys.stdin)
        
        # Check if it's a file modification tool
        if tool_use.get("tool") in ["Write", "Edit", "MultiEdit"]:
            file_path = tool_use.get("input", {}).get("file_path")
            
            if file_path:
                lint_result = lint_file(file_path)
                
                # Return result with message for Claude
                response = {
                    "action": "allow",
                    "message": lint_result["message"]
                }
                
                # Add Batman theming for consistency
                if not lint_result["success"]:
                    response["message"] = f"🦇 Batcave Alert: {response['message']}"
                else:
                    response["message"] = f"🦇 Batcave: {response['message']}"
                
                print(json.dumps(response))
                return
        
        # Default response for non-file operations
        print(json.dumps({"action": "allow"}))
        
    except Exception as e:
        # Report hook errors to Claude
        print(json.dumps({
            "action": "allow",
            "message": f"🦇 Batcave Linter System Error: {str(e)}"
        }))

if __name__ == "__main__":
    main()