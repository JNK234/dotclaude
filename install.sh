#!/bin/bash

# ABOUTME: Claude Code Configuration Installer
# ABOUTME: Installs hooks, commands, skills, agents, scripts, settings, and configures shell

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SHELL_CONFIG=""
FORCE=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --force|-f) FORCE=true ;;
    esac
done

# Detect shell config file
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

echo "Installing Claude Code Configuration..."
echo "========================================"

# Ask for notification name
echo ""
read -p "Enter your name for voice notifications (default: Master Wayne): " USER_NAME
USER_NAME="${USER_NAME:-Master Wayne}"
echo "Voice notifications will address you as: $USER_NAME"
echo ""

# Create directories
echo "Creating directory structure..."
mkdir -p "$CLAUDE_DIR"/{hooks/{pre_tool_use,post_tool_use,notification,session,stop},commands,skills,agents,profiles,scripts}

# Copy settings
if [ ! -f "$CLAUDE_DIR/settings.json" ] || [ "$FORCE" = true ]; then
    echo "Installing settings.json..."
    cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
else
    echo "settings.json exists, skipping (use --force to overwrite)"
fi

# Copy CLAUDE.md
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ] || [ "$FORCE" = true ]; then
    echo "Installing CLAUDE.md..."
    cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
else
    echo "CLAUDE.md exists, skipping (use --force to overwrite)"
fi

# Copy hooks
echo "Installing hooks..."
cp "$SCRIPT_DIR/hooks/pre_tool_use/"*.py "$CLAUDE_DIR/hooks/pre_tool_use/" 2>/dev/null || true
cp "$SCRIPT_DIR/hooks/post_tool_use/"*.py "$CLAUDE_DIR/hooks/post_tool_use/" 2>/dev/null || true
cp "$SCRIPT_DIR/hooks/notification/"*.py "$CLAUDE_DIR/hooks/notification/" 2>/dev/null || true
cp "$SCRIPT_DIR/hooks/session/"*.py "$CLAUDE_DIR/hooks/session/" 2>/dev/null || true
cp "$SCRIPT_DIR/hooks/stop/"*.py "$CLAUDE_DIR/hooks/stop/" 2>/dev/null || true

# Customize voice notification with user's name
if [ -f "$CLAUDE_DIR/hooks/notification/voice_notify.py" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/Master Wayne/$USER_NAME/g" "$CLAUDE_DIR/hooks/notification/voice_notify.py"
    else
        sed -i "s/Master Wayne/$USER_NAME/g" "$CLAUDE_DIR/hooks/notification/voice_notify.py"
    fi
fi

# Make hooks executable
chmod +x "$CLAUDE_DIR/hooks/"*/*.py 2>/dev/null || true

# Copy statusline script
echo "Installing statusline script..."
cp "$SCRIPT_DIR/statusline-script.sh" "$CLAUDE_DIR/statusline-script.sh"
chmod +x "$CLAUDE_DIR/statusline-script.sh"

# Copy commands
echo "Installing commands..."
cp "$SCRIPT_DIR/commands/"*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true

# Copy skills (recursive - preserves subdirectories and references)
echo "Installing skills..."
if [ -d "$SCRIPT_DIR/skills" ]; then
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        skill_name=$(basename "$skill_dir")
        mkdir -p "$CLAUDE_DIR/skills/$skill_name"
        cp -r "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/" 2>/dev/null || true
    done
fi

# Copy agents
echo "Installing agents..."
cp "$SCRIPT_DIR/agents/"*.md "$CLAUDE_DIR/agents/" 2>/dev/null || true

# Copy profiles
echo "Installing profiles..."
cp "$SCRIPT_DIR/profiles/"*.json "$CLAUDE_DIR/profiles/" 2>/dev/null || true
cp "$SCRIPT_DIR/profiles/"*.template "$CLAUDE_DIR/profiles/" 2>/dev/null || true

# Copy scripts (all files, not just *.sh)
echo "Installing scripts..."
cp "$SCRIPT_DIR/scripts/"* "$CLAUDE_DIR/scripts/" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/scripts/"* 2>/dev/null || true

# Add profile switcher to shell config
PROFILE_SOURCE='source ~/.claude/scripts/profile-switcher.sh'

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q "profile-switcher.sh" "$SHELL_CONFIG" 2>/dev/null; then
        echo ""
        echo "Adding profile switcher to $SHELL_CONFIG..."
        echo "" >> "$SHELL_CONFIG"
        echo "# Claude Code Profile Switcher" >> "$SHELL_CONFIG"
        echo "$PROFILE_SOURCE" >> "$SHELL_CONFIG"
        echo "Added to $SHELL_CONFIG"
    else
        echo "Profile switcher already in $SHELL_CONFIG"
    fi
else
    echo ""
    echo "Could not detect shell config. Manually add to your shell config:"
    echo "  $PROFILE_SOURCE"
fi

echo ""
echo "========================================"
echo "Installation complete!"
echo "========================================"
echo ""
echo "Restart your terminal or run:"
echo "  source $SHELL_CONFIG"
echo ""
echo "Installed:"
echo "  Hooks:    pre_tool_use, post_tool_use, notification, session, stop"
echo "  Commands: $(ls "$SCRIPT_DIR/commands/"*.md 2>/dev/null | wc -l | tr -d ' ') slash commands"
echo "  Skills:   $(ls -d "$SCRIPT_DIR/skills"/*/ 2>/dev/null | wc -l | tr -d ' ') skill directories"
echo "  Agents:   $(ls "$SCRIPT_DIR/agents/"*.md 2>/dev/null | wc -l | tr -d ' ') agent configs"
echo "  Scripts:  $(ls "$SCRIPT_DIR/scripts/"* 2>/dev/null | wc -l | tr -d ' ') shell utilities"
echo ""
echo "Profile switching:"
echo "  use-claude       - Anthropic Claude (default)"
echo "  use-openrouter   - OpenRouter (400+ models)"
echo "  use-minimax      - MiniMax M2"
echo "  use-kimi         - Kimi (Moonshot AI)"
echo "  use-glm          - GLM (Zhipu AI)"
echo "  claude-profile   - Show current profile"
echo "  claude-profiles  - List all profiles"
echo ""
echo "To setup a provider:"
echo "  cp ~/.claude/profiles/openrouter.json.template ~/.claude/profiles/openrouter.json"
echo "  # Edit and add your API key, then: use-openrouter"
echo ""
