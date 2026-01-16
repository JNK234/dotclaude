#!/bin/bash

# ABOUTME: Enhanced statusline with repo, branch, model, time, username, and inspirational quotes
# ABOUTME: Displays comprehensive project context with motivational messages for developers

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

# Array of inspirational quotes for building/coding
quotes=(
    "Ship it! 🚀"
    "Code is poetry 📝"
    "Build something amazing ⚡"
    "Keep pushing forward 💪"
    "Debug today, deploy tomorrow 🎯"
    "Every bug is a lesson 🐛"
    "Commit to excellence ✨"
    "Refactor with purpose 🔧"
    "Test, then test again ✅"
    "Innovation starts here 💡"
    "Clean code, clear mind 🧘"
    "Progress over perfection 📈"
    "Deploy with confidence 🎪"
    "Solve problems, create value 💎"
    "Code with passion 🔥"
    "Build the future 🏗️"
    "One line at a time ⌨️"
    "Transform ideas into reality 🌟"
    "Embrace the challenge 🎮"
    "Create, iterate, improve 🔄"
)

# Select a random quote
# Use the current second as a seed for some variety that changes over time
second=$(date '+%S')
quote_index=$((second % ${#quotes[@]}))
random_quote="${quotes[$quote_index]}"

# Clean statusline with all requested elements
printf "%s | %s | %s | %s | %s | %s" \
    "$project_name" \
    "$git_branch" \
    "$model_info" \
    "$current_time" \
    "$username" \
    "$random_quote"