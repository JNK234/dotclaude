#!/bin/bash
# ABOUTME: Git worktree automation for parallel Claude development
# ABOUTME: Creates isolated worktrees with config copying and terminal launching

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Get project name and task
PROJECT_NAME=$(basename $PWD)
TASK_ID=${1:-""}

if [ -z "$TASK_ID" ]; then
    echo -e "${RED}Usage: $0 <task-id>${NC}"
    echo "Example: $0 issue-123"
    exit 1
fi

# Configuration
BRANCH="feature/${TASK_ID}"
WORKTREES_DIR="../${PROJECT_NAME}-worktrees"
WORKTREE_PATH="${WORKTREES_DIR}/${TASK_ID}"

echo -e "${BLUE}Creating worktree for ${TASK_ID}...${NC}"

# Create worktrees directory if it doesn't exist
mkdir -p "$WORKTREES_DIR"

# Check if worktree already exists
if [ -d "$WORKTREE_PATH" ]; then
    echo -e "${RED}Worktree already exists at ${WORKTREE_PATH}${NC}"
    exit 1
fi

# Create the worktree
echo -e "${GREEN}Creating worktree...${NC}"
git worktree add "$WORKTREE_PATH" -b "$BRANCH" || {
    echo -e "${RED}Failed to create worktree. Branch might already exist.${NC}"
    exit 1
}

# Copy essential files
echo -e "${GREEN}Copying configuration files...${NC}"
cp -r .claude "$WORKTREE_PATH/" 2>/dev/null || echo "No .claude directory to copy"
cp .env* "$WORKTREE_PATH/" 2>/dev/null || echo "No .env files to copy"
cp CLAUDE.md "$WORKTREE_PATH/" 2>/dev/null || echo "No CLAUDE.md to copy"

# Platform-specific terminal launch
if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v iterm2 &> /dev/null; then
        osascript <<EOF
tell application "iTerm2"
    create window with default profile
    tell current session of current window
        write text "cd '$WORKTREE_PATH' && claude /ship '$TASK_ID' --dangerous"
    end tell
end tell
EOF
    else
        osascript <<EOF
tell application "Terminal"
    do script "cd '$WORKTREE_PATH' && claude /ship '$TASK_ID' --dangerous"
end tell
EOF
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal -- bash -c "cd '$WORKTREE_PATH' && claude /ship '$TASK_ID' --dangerous; exec bash"
    elif command -v xterm &> /dev/null; then
        xterm -e "cd '$WORKTREE_PATH' && claude /ship '$TASK_ID' --dangerous; bash" &
    else
        echo -e "${BLUE}Please manually open a terminal and run:${NC}"
        echo "cd '$WORKTREE_PATH' && claude /ship '$TASK_ID' --dangerous"
    fi
fi

echo -e "${GREEN}Worktree created at: ${WORKTREE_PATH}${NC}"
echo -e "${BLUE}Claude is starting work on ${TASK_ID}...${NC}"
