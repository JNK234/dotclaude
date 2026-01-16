#!/bin/bash

# ABOUTME: Enhanced statusline showing repo, branch, model, time, and username
# ABOUTME: Displays comprehensive project context in Claude Code status bar

# Read Claude Code JSON input
input=$(cat)

# Extract essential data from JSON
project_name=$(basename "$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir // .cwd')")
model_info=$(echo "$input" | jq -r '.model.display_name // .model.id // "Unknown"')

# Git branch information
if git rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git --no-optional-locks branch --show-current 2>/dev/null || echo "detached")
    if [ -z "$git_branch" ]; then
        git_branch="detached"
    fi
else
    git_branch="no-git"
fi

# Get current time
current_time=$(date '+%H:%M')

# Get username
username=$(whoami)

# Clean statusline with essential elements
printf "%s | %s | %s | %s | %s" \
    "$project_name" \
    "$git_branch" \
    "$model_info" \
    "$current_time" \
    "$username"
