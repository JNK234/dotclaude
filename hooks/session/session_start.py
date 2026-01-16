#!/usr/bin/env python3
"""
ABOUTME: SessionStart hook - loads project context when Claude Code starts
ABOUTME: Detects project type, shows git status, recent changes, and sets up environment
"""

import json
import sys
import os
import subprocess
from pathlib import Path

def run_cmd(cmd, cwd=None):
    """Run a command and return output, empty string on failure"""
    try:
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True,
            timeout=5, cwd=cwd or os.getcwd()
        )
        return result.stdout.strip()
    except:
        return ""

def detect_project_type(cwd):
    """Detect the project type based on config files"""
    indicators = {
        "package.json": "Node.js",
        "requirements.txt": "Python",
        "pyproject.toml": "Python",
        "Cargo.toml": "Rust",
        "go.mod": "Go",
        "pom.xml": "Java (Maven)",
        "build.gradle": "Java (Gradle)",
        "Gemfile": "Ruby",
        "composer.json": "PHP",
        "mix.exs": "Elixir",
        "Makefile": "Make",
        "Dockerfile": "Docker",
        "docker-compose.yml": "Docker Compose",
    }

    detected = []
    for file, project_type in indicators.items():
        if Path(cwd, file).exists():
            detected.append(project_type)

    return detected if detected else ["Unknown"]

def get_git_context(cwd):
    """Get relevant git context"""
    context = {}

    # Check if git repo
    if not Path(cwd, ".git").exists():
        return {"is_git": False}

    context["is_git"] = True
    context["branch"] = run_cmd("git branch --show-current", cwd)
    context["status_short"] = run_cmd("git status --short", cwd)
    context["recent_commits"] = run_cmd("git log --oneline -5", cwd)
    context["uncommitted_changes"] = len(context["status_short"].split("\n")) if context["status_short"] else 0

    # Get files changed in last commit
    context["last_commit_files"] = run_cmd("git diff-tree --no-commit-id --name-only -r HEAD", cwd)

    return context

def get_todo_context(cwd):
    """Check for TODO files or task management"""
    todo_files = ["TODO.md", "TODO", "TASKS.md", ".todo", "tasks.json"]
    for f in todo_files:
        path = Path(cwd, f)
        if path.exists():
            try:
                content = path.read_text()[:500]  # First 500 chars
                return {"file": f, "preview": content}
            except:
                pass
    return None

def build_context_message(cwd):
    """Build the context message to inject"""
    lines = []

    # Project type
    project_types = detect_project_type(cwd)
    lines.append(f"Project: {', '.join(project_types)}")

    # Git context
    git = get_git_context(cwd)
    if git.get("is_git"):
        lines.append(f"Branch: {git.get('branch', 'unknown')}")

        if git.get("uncommitted_changes", 0) > 0:
            lines.append(f"Uncommitted: {git['uncommitted_changes']} file(s)")
            # Show first few changed files
            if git.get("status_short"):
                changes = git["status_short"].split("\n")[:3]
                for change in changes:
                    lines.append(f"  {change}")
                if len(git["status_short"].split("\n")) > 3:
                    lines.append(f"  ... and more")

        if git.get("recent_commits"):
            lines.append("Recent commits:")
            for commit in git["recent_commits"].split("\n")[:3]:
                lines.append(f"  {commit}")
    else:
        lines.append("Git: Not a repository")

    # TODO context
    todo = get_todo_context(cwd)
    if todo:
        lines.append(f"TODO file found: {todo['file']}")

    return "\n".join(lines)

def main():
    """Main entry point for SessionStart hook"""
    try:
        # Read session data from stdin
        input_data = sys.stdin.read()
        session_data = json.loads(input_data) if input_data.strip() else {}

        # Get current working directory
        cwd = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())

        # Build context
        context = build_context_message(cwd)

        # Output context for Claude
        response = {
            "continue": True,
            "systemMessage": f"Session Context:\n{context}"
        }

        print(json.dumps(response))

    except Exception as e:
        # Don't block on errors
        print(json.dumps({
            "continue": True,
            "systemMessage": f"SessionStart hook error: {str(e)}"
        }))

if __name__ == "__main__":
    main()
