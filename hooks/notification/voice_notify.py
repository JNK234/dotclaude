#!/usr/bin/env python3
"""
ABOUTME: Voice notifications for Claude Code using system audio
ABOUTME: Provides audio alerts when Claude needs user input
"""

import json
import sys
import subprocess
import platform
import os

AUDIO_DIR = os.path.dirname(os.path.abspath(__file__))

def play_audio(audio_file):
    """Play audio file using appropriate system command"""
    if not os.path.exists(audio_file):
        print("\a")  # Fallback to terminal bell
        return

    system = platform.system()

    try:
        if system == "Darwin":  # macOS
            subprocess.run(["afplay", audio_file], check=True)
        elif system == "Linux":
            for player in ["aplay", "mpg123", "ffplay", "paplay"]:
                try:
                    subprocess.run([player, audio_file], check=True,
                                 stderr=subprocess.DEVNULL)
                    return
                except:
                    continue
        elif system == "Windows":
            subprocess.run(["powershell", "-Command",
                          f"(New-Object Media.SoundPlayer '{audio_file}').PlaySync()"])
    except:
        print("\a")

def main():
    """Main entry point for the hook"""
    try:
        notification = json.load(sys.stdin)
        message = notification.get("message", "")

        # Play notification sound for input requests
        if "needs your input" in message.lower() or "waiting" in message.lower():
            audio_file = os.path.join(AUDIO_DIR, "notify.mp3")
            if os.path.exists(audio_file):
                play_audio(audio_file)
            else:
                print("\a")  # Terminal bell fallback
        else:
            print("\a")

        print(json.dumps({"action": "allow"}))

    except Exception as e:
        print(json.dumps({"action": "allow"}))

if __name__ == "__main__":
    main()
