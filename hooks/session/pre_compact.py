#!/usr/bin/env python3
"""Pre-compact hook - saves conversation context before compacting"""

import json
import os
from datetime import datetime
from pathlib import Path

def save_pre_compact():
    cwd = os.getcwd()

    # Find active session
    sessions_dir = Path(cwd) / ".claude" / "sessions"
    active_dir = sessions_dir / "active"

    if not active_dir.exists():
        print("No active sessions directory found")
        return

    active_sessions = list(active_dir.glob("session_*.json"))
    if not active_sessions:
        print("No active session found to backup")
        return

    # Get most recent session
    latest_session = max(active_sessions, key=lambda f: f.stat().st_mtime)

    with open(latest_session, 'r') as f:
        metadata = json.load(f)

    # Add pre-compact marker
    metadata["last_compact"] = datetime.now().isoformat()
    metadata["compact_count"] = metadata.get("compact_count", 0) + 1

    # Save updated metadata
    with open(latest_session, 'w') as f:
        json.dump(metadata, f, indent=2)

    print(f"Pre-compact backup for session: {metadata['session_id']}")

if __name__ == "__main__":
    save_pre_compact()
