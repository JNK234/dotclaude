#!/usr/bin/env python3
"""
Batcave Progress Tracker Hook for Claude Code
Tracks progress of operations and provides Batman-themed status updates.
"""

import json
import sys
import os
import time
from datetime import datetime
from pathlib import Path

# Progress tracking file location
PROGRESS_FILE = os.path.expanduser("~/.claude/progress.json")

def load_progress():
    """Load existing progress data."""
    if os.path.exists(PROGRESS_FILE):
        try:
            with open(PROGRESS_FILE, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return {}
    return {}

def save_progress(progress_data):
    """Save progress data to file."""
    try:
        # Ensure directory exists
        os.makedirs(os.path.dirname(PROGRESS_FILE), exist_ok=True)
        
        with open(PROGRESS_FILE, 'w') as f:
            json.dump(progress_data, f, indent=2)
    except IOError:
        # Silently fail if can't write progress
        pass

def track_operation(tool_data):
    """
    Track the progress of a tool operation.
    
    Args:
        tool_data: Dictionary containing tool completion information
        
    Returns:
        dict: Response with action (always allow for post-tool hooks)
    """
    tool_name = tool_data.get('tool_name', '')
    parameters = tool_data.get('parameters', {})
    success = tool_data.get('success', True)
    timestamp = datetime.now().isoformat()
    
    # Load existing progress
    progress = load_progress()
    
    # Initialize session if needed
    session_id = f"session_{int(time.time())}"
    if 'current_session' not in progress:
        progress['current_session'] = session_id
        progress['sessions'] = {}
    
    current_session = progress['current_session']
    if current_session not in progress['sessions']:
        progress['sessions'][current_session] = {
            'start_time': timestamp,
            'operations': [],
            'stats': {
                'total_operations': 0,
                'successful_operations': 0,
                'failed_operations': 0,
                'files_modified': 0,
                'commands_executed': 0
            }
        }
    
    session_data = progress['sessions'][current_session]
    
    # Track the operation
    operation = {
        'tool_name': tool_name,
        'timestamp': timestamp,
        'success': success,
        'parameters': parameters
    }
    
    session_data['operations'].append(operation)
    session_data['stats']['total_operations'] += 1
    
    if success:
        session_data['stats']['successful_operations'] += 1
    else:
        session_data['stats']['failed_operations'] += 1
    
    # Track specific operation types
    if tool_name == 'Bash':
        session_data['stats']['commands_executed'] += 1
    elif tool_name in ['Write', 'Edit', 'MultiEdit']:
        session_data['stats']['files_modified'] += 1
    
    # Update last activity
    session_data['last_activity'] = timestamp
    
    # Save progress
    save_progress(progress)
    
    # Generate Batman-themed progress message
    stats = session_data['stats']
    
    # Batman-themed progress messages
    if stats['successful_operations'] == stats['total_operations']:
        message = f"🦇 Batcave Report: All {stats['total_operations']} operations successful. Gotham remains secure."
    else:
        message = f"🦇 Batcave Report: {stats['successful_operations']}/{stats['total_operations']} operations successful. Continuing mission."
    
    if stats['files_modified'] > 0:
        message += f" Wayne Tech modified {stats['files_modified']} files."
    
    if stats['commands_executed'] > 0:
        message += f" Executed {stats['commands_executed']} Batcave protocols."
    
    return {
        "action": "allow",
        "message": message
    }

def main():
    """Main entry point for the progress tracker hook."""
    try:
        # Read input from stdin
        input_data = sys.stdin.read()
        if not input_data.strip():
            print(json.dumps({"action": "allow"}))
            return
        
        # Parse JSON input
        tool_data = json.loads(input_data)
        
        # Track progress
        response = track_operation(tool_data)
        
        # Output response
        print(json.dumps(response))
        
    except json.JSONDecodeError:
        # Invalid JSON input - allow by default
        print(json.dumps({"action": "allow"}))
    except Exception as e:
        # Any other error - allow by default
        print(json.dumps({
            "action": "allow",
            "message": f"🦇 Batcave systems encountered an issue: {str(e)}"
        }))

if __name__ == "__main__":
    main()