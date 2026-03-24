#!/bin/bash
# ABOUTME: Claude Squad - Run multiple Claude instances in parallel using tmux
# ABOUTME: Creates a tmux session with N panes, each running a Claude instance on todo items

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
TASK_COUNT=${1:-3}
SESSION_NAME="claude-squad"

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo -e "${RED}tmux is required but not installed. Please install tmux first.${NC}"
    exit 1
fi

# Kill existing session if it exists
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

echo -e "${BLUE}Launching Claude Squad with ${TASK_COUNT} instances...${NC}"

# Create new tmux session
tmux new-session -d -s "$SESSION_NAME" -n "squad"

# Create the layout based on task count
if [ "$TASK_COUNT" -eq 1 ]; then
    :
elif [ "$TASK_COUNT" -eq 2 ]; then
    tmux split-window -h -t "$SESSION_NAME:0"
elif [ "$TASK_COUNT" -eq 3 ]; then
    tmux split-window -h -t "$SESSION_NAME:0"
    tmux split-window -v -t "$SESSION_NAME:0.0"
elif [ "$TASK_COUNT" -eq 4 ]; then
    tmux split-window -h -t "$SESSION_NAME:0"
    tmux split-window -v -t "$SESSION_NAME:0.0"
    tmux split-window -v -t "$SESSION_NAME:0.1"
else
    for ((i=2; i<=$TASK_COUNT; i++)); do
        tmux split-window -t "$SESSION_NAME:0"
    done
    tmux select-layout -t "$SESSION_NAME:0" tiled
fi

# Read todo items if todo.md exists
TODO_ITEMS=()
if [ -f "todo.md" ]; then
    while IFS= read -r line; do
        if [[ $line =~ ^-[[:space:]]\[[[:space:]]\][[:space:]].+ ]]; then
            task=$(echo "$line" | sed 's/^-[[:space:]]\[[[:space:]]\][[:space:]]//')
            TODO_ITEMS+=("$task")
        fi
    done < "todo.md"
fi

# Launch Claude in each pane
for ((i=0; i<$TASK_COUNT; i++)); do
    if [ ${#TODO_ITEMS[@]} -gt $i ]; then
        TASK="${TODO_ITEMS[$i]}"
        tmux send-keys -t "$SESSION_NAME:0.$i" "claude /ship \"$TASK\" --dangerous" C-m
    else
        tmux send-keys -t "$SESSION_NAME:0.$i" "claude /execute todo --dangerous" C-m
    fi
done

# Add status bar with custom format
tmux set -t "$SESSION_NAME" status on
tmux set -t "$SESSION_NAME" status-interval 1
tmux set -t "$SESSION_NAME" status-left "#[fg=green]Claude Squad "
tmux set -t "$SESSION_NAME" status-right "#[fg=yellow]Tasks: $TASK_COUNT | #[fg=cyan]%H:%M:%S"

# Add pane borders and titles
tmux set -t "$SESSION_NAME" pane-border-status top
tmux set -t "$SESSION_NAME" pane-border-format "#[fg=cyan]Claude Instance #P"

# Attach to the session
echo -e "${GREEN}Claude Squad launched with $TASK_COUNT instances${NC}"
echo -e "${YELLOW}Tip: Use Ctrl+B then arrow keys to navigate between panes${NC}"
echo -e "${YELLOW}     Use Ctrl+B then 'z' to zoom into a pane${NC}"
echo -e "${YELLOW}     Use Ctrl+B then 'd' to detach${NC}"

tmux attach-session -t "$SESSION_NAME"
