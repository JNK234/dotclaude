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
        echo "Models available: claude-sonnet-4.5, claude-opus-4.1, gemini-2.0-flash"
    else
        echo "OpenRouter profile not found. Copy openrouter.json.template to openrouter.json and add your API key."
    fi
}

# Check current profile
claude-profile() {
    if grep -q "openrouter.ai/api" ~/.claude/settings.json 2>/dev/null; then
        echo "Current: OpenRouter"
    else
        echo "Current: Anthropic Claude (default)"
    fi
}

# List available profiles
claude-profiles() {
    echo "Available profiles:"
    echo "  use-claude     - Anthropic Claude (default)"
    echo "  use-openrouter - OpenRouter (400+ models)"
}

# Reset to default Anthropic Claude
claude-reset() {
    unset API_TIMEOUT_MS CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
    use-claude
    echo "Claude environment reset to Anthropic defaults"
}
