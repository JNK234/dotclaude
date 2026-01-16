#!/usr/bin/env python3
"""
ABOUTME: Batman-themed voice notifications for Claude Code using ElevenLabs Alfred voice
ABOUTME: Provides Master Wayne with audio updates from the Batcave using pre-generated audio files
"""

import json
import sys
import subprocess
import platform
import os

# Path to audio files directory
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
            # Try multiple audio players
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
        # Fallback to terminal bell if audio fails
        print("\a")

def main():
    """Main entry point for the hook"""
    try:
        # Read notification from stdin
        notification = json.load(sys.stdin)

        message = notification.get("message", "")

        # Use the Alfred voice audio for "needs your input" messages
        if "needs your input" in message.lower() or "waiting" in message.lower():
            audio_file = os.path.join(AUDIO_DIR, "master_wayne_notify.mp3")
            play_audio(audio_file)
        else:
            # For other messages, just play a simple notification sound
            # You could generate more audio files for different scenarios
            print("\a")

        # Always allow
        print(json.dumps({"action": "allow"}))

    except Exception as e:
        print(json.dumps({"action": "allow"}))

if __name__ == "__main__":
    main()
