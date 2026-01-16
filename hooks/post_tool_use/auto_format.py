#!/usr/bin/env python3
"""
ABOUTME: Auto-format code after file modifications with robust error reporting
ABOUTME: Reports formatting failures back to Claude Code instead of failing silently
"""

import json
import sys
import subprocess
import os

FORMATTERS = {
    # JavaScript/TypeScript
    ('.js', '.jsx', '.ts', '.tsx'): ['prettier', '--write'],
    ('.json',): ['prettier', '--write'],
    
    # Python
    ('.py',): ['black'],
    
    # Go
    ('.go',): ['gofmt', '-w'],
    
    # Rust
    ('.rs',): ['rustfmt'],
    
    # Ruby
    ('.rb',): ['rubocop', '-a'],
    
    # CSS/SCSS
    ('.css', '.scss', '.sass'): ['prettier', '--write'],
    
    # Markdown
    ('.md',): ['prettier', '--write'],
    
    # YAML
    ('.yml', '.yaml'): ['prettier', '--write'],
}

def format_file(file_path):
    """Format a file based on its extension and return result details"""
    if not os.path.exists(file_path):
        return {
            "success": False,
            "message": f"File not found: {os.path.basename(file_path)}"
        }
    
    # Find appropriate formatter
    for extensions, formatter_cmd in FORMATTERS.items():
        if any(file_path.endswith(ext) for ext in extensions):
            try:
                # Check if formatter exists
                subprocess.run(['which', formatter_cmd[0]], 
                             check=True, capture_output=True)
                
                # Run formatter
                cmd = formatter_cmd + [file_path]
                result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
                
                if result.returncode == 0:
                    return {
                        "success": True,
                        "message": f"✅ {os.path.basename(file_path)}: Formatted with {formatter_cmd[0]}"
                    }
                else:
                    error_msg = result.stderr.strip() or result.stdout.strip() or "Unknown formatting error"
                    return {
                        "success": False,
                        "message": f"🚨 FORMATTING FAILED for {os.path.basename(file_path)}: {error_msg}"
                    }
                
            except subprocess.CalledProcessError:
                # Formatter not installed
                return {
                    "success": False,
                    "message": f"⚠️ Formatter {formatter_cmd[0]} not installed for {os.path.basename(file_path)}"
                }
            except subprocess.TimeoutExpired:
                return {
                    "success": False,
                    "message": f"🚨 FORMATTING TIMEOUT for {os.path.basename(file_path)}: {formatter_cmd[0]} took too long"
                }
            except Exception as e:
                return {
                    "success": False,
                    "message": f"🚨 FORMATTING ERROR for {os.path.basename(file_path)}: {str(e)}"
                }
            break
    
    # No formatter found for this file type
    return {
        "success": True,
        "message": f"No formatter configured for {os.path.basename(file_path)}"
    }

def main():
    """Main entry point for the hook"""
    try:
        # Read tool use from stdin
        tool_use = json.load(sys.stdin)
        
        # Check if it's a file modification tool
        if tool_use.get("tool") in ["Write", "Edit", "MultiEdit"]:
            file_path = tool_use.get("input", {}).get("file_path")
            
            if file_path:
                format_result = format_file(file_path)
                
                # Report result back to Claude with Batman theming
                response = {
                    "action": "allow",
                    "message": f"🦇 Batcave Auto-Format: {format_result['message']}"
                }
                
                print(json.dumps(response))
                return
        
        # Default response for non-file operations
        print(json.dumps({"action": "allow"}))
        
    except Exception as e:
        # Report hook errors to Claude
        print(json.dumps({
            "action": "allow",
            "message": f"🦇 Batcave Auto-Format System Error: {str(e)}"
        }))

if __name__ == "__main__":
    main()