#!/usr/bin/env python3
"""Simple session checker"""

import json
import os
from pathlib import Path

def check_sessions():
    # Check sessions in current working directory's .claude folder
    cwd = os.getcwd()
    sessions_dir = Path(cwd) / ".claude" / "sessions"

    print(f"Checking sessions in: {sessions_dir}")

    print("\n=== Active Sessions ===")
    active_dir = sessions_dir / "active"
    if active_dir.exists():
        for session_file in active_dir.glob("*.json"):
            with open(session_file) as f:
                data = json.load(f)
            print(f"  {data['session_id']} - {data['start_time']} - {data['working_directory']}")
    else:
        print("  No active sessions directory found")

    print("\n=== Archived Sessions ===")
    archive_dir = sessions_dir / "archive"
    if archive_dir.exists():
        for session_file in archive_dir.glob("*.json"):
            with open(session_file) as f:
                data = json.load(f)
            duration = "ongoing" if "end_time" not in data else "ended"
            print(f"  {data['session_id']} - {data['start_time']} - {duration}")
    else:
        print("  No archive directory found")

if __name__ == "__main__":
    check_sessions()
