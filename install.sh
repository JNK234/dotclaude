#!/bin/bash

# ABOUTME: Claude Code Configuration Installer
# ABOUTME: Installs hooks, commands, agents, and settings to ~/.claude

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing Claude Code Configuration..."
echo "========================================"

# Create directories
echo "Creating directory structure..."
mkdir -p "$CLAUDE_DIR"/{hooks/{pre_tool_use,post_tool_use,notification,session},commands,agents,profiles,scripts}

# Copy settings
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
    echo "Installing settings.json..."
    cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
else
    echo "settings.json exists, skipping (use --force to overwrite)"
fi

# Copy CLAUDE.md
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "Installing CLAUDE.md..."
    cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
else
    echo "CLAUDE.md exists, skipping"
fi

# Copy hooks
echo "Installing hooks..."
cp "$SCRIPT_DIR/hooks/pre_tool_use/"*.py "$CLAUDE_DIR/hooks/pre_tool_use/" 2>/dev/null || true
cp "$SCRIPT_DIR/hooks/post_tool_use/"*.py "$CLAUDE_DIR/hooks/post_tool_use/" 2>/dev/null || true
cp "$SCRIPT_DIR/hooks/notification/"*.py "$CLAUDE_DIR/hooks/notification/" 2>/dev/null || true

# Make hooks executable
chmod +x "$CLAUDE_DIR/hooks/"*/*.py 2>/dev/null || true

# Copy statusline script
echo "Installing statusline script..."
cp "$SCRIPT_DIR/statusline-script.sh" "$CLAUDE_DIR/statusline-script.sh"
chmod +x "$CLAUDE_DIR/statusline-script.sh"

# Copy commands
echo "Installing commands..."
cp "$SCRIPT_DIR/commands/"*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true

# Copy agents
echo "Installing agents..."
cp "$SCRIPT_DIR/agents/"*.md "$CLAUDE_DIR/agents/" 2>/dev/null || true

# Copy profiles
echo "Installing profiles..."
cp "$SCRIPT_DIR/profiles/"*.json "$CLAUDE_DIR/profiles/" 2>/dev/null || true
cp "$SCRIPT_DIR/profiles/"*.template "$CLAUDE_DIR/profiles/" 2>/dev/null || true

# Copy scripts
echo "Installing scripts..."
cp "$SCRIPT_DIR/scripts/"*.sh "$CLAUDE_DIR/scripts/" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/scripts/"*.sh 2>/dev/null || true

echo ""
echo "Installation complete!"
echo ""
echo "To enable profile switching, add to your ~/.zshrc or ~/.bashrc:"
echo ""
echo "  source ~/.claude/scripts/profile-switcher.sh"
echo ""
echo "Available commands after sourcing:"
echo "  use-claude       - Switch to Anthropic Claude"
echo "  use-openrouter   - Switch to OpenRouter (setup API key first)"
echo "  claude-profile   - Show current profile"
echo "  claude-profiles  - List available profiles"
echo ""
echo "For OpenRouter setup:"
echo "  1. Copy ~/.claude/profiles/openrouter.json.template to openrouter.json"
echo "  2. Replace YOUR_OPENROUTER_API_KEY_HERE with your API key"
echo ""
