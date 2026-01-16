#!/bin/bash

# ABOUTME: Claude Code Profile Switcher Functions
# ABOUTME: Add these functions to your .zshrc or .bashrc to switch between providers

# === Claude Code Profile Switcher ===

# Switch to Anthropic Claude (default)
use-claude() {
    cp ~/.claude/profiles/claude.json ~/.claude/settings.json 2>/dev/null
    echo "Switched to Anthropic Claude"
}

# Switch to OpenRouter (requires API key setup)
use-openrouter() {
    if [ -f ~/.claude/profiles/openrouter.json ]; then
        cp ~/.claude/profiles/openrouter.json ~/.claude/settings.json
        echo "Switched to OpenRouter"
        echo "Models: claude-sonnet-4.5, claude-opus-4.1, gemini-2.0-flash"
    else
        echo "OpenRouter profile not found."
        echo "Setup: cp ~/.claude/profiles/openrouter.json.template ~/.claude/profiles/openrouter.json"
        echo "Then add your API key to the file."
    fi
}

# Switch to MiniMax
use-minimax() {
    if [ -f ~/.claude/profiles/minimax.json ]; then
        cp ~/.claude/profiles/minimax.json ~/.claude/settings.json
        echo "Switched to MiniMax M2"
    else
        echo "MiniMax profile not found."
        echo "Setup: cp ~/.claude/profiles/minimax.json.template ~/.claude/profiles/minimax.json"
        echo "Then add your API key to the file."
    fi
}

# Switch to Kimi (Moonshot)
use-kimi() {
    if [ -f ~/.claude/profiles/kimi.json ]; then
        cp ~/.claude/profiles/kimi.json ~/.claude/settings.json
        echo "Switched to Kimi (Moonshot AI)"
        echo "Models: kimi-k2-thinking, kimi-k2-thinking-turbo"
    else
        echo "Kimi profile not found."
        echo "Setup: cp ~/.claude/profiles/kimi.json.template ~/.claude/profiles/kimi.json"
        echo "Then add your API key to the file."
    fi
}

# Switch to GLM (Zhipu AI)
use-glm() {
    if [ -f ~/.claude/profiles/glm.json ]; then
        cp ~/.claude/profiles/glm.json ~/.claude/settings.json
        echo "Switched to GLM (Zhipu AI)"
        echo "Models: glm-4.7, glm-4.5-air"
    else
        echo "GLM profile not found."
        echo "Setup: cp ~/.claude/profiles/glm.json.template ~/.claude/profiles/glm.json"
        echo "Then add your API key to the file."
    fi
}

# Check current profile
claude-profile() {
    if grep -q "openrouter.ai/api" ~/.claude/settings.json 2>/dev/null; then
        echo "Current: OpenRouter"
    elif grep -q "api.minimax.io" ~/.claude/settings.json 2>/dev/null; then
        echo "Current: MiniMax M2"
    elif grep -q "api.kimi.com" ~/.claude/settings.json 2>/dev/null; then
        echo "Current: Kimi (Moonshot AI)"
    elif grep -q "api.z.ai" ~/.claude/settings.json 2>/dev/null; then
        echo "Current: GLM (Zhipu AI)"
    else
        echo "Current: Anthropic Claude (default)"
    fi
}

# List available profiles
claude-profiles() {
    echo "Available profiles:"
    echo "  use-claude     - Anthropic Claude (default)"
    echo "  use-openrouter - OpenRouter (400+ models)"
    echo "  use-minimax    - MiniMax M2"
    echo "  use-kimi       - Kimi (Moonshot AI)"
    echo "  use-glm        - GLM (Zhipu AI)"
}

# Reset to default Anthropic Claude
claude-reset() {
    unset API_TIMEOUT_MS CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
    use-claude
    echo "Claude environment reset to Anthropic defaults"
}
