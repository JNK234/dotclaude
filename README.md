# dotclaude

Personal Claude Code configuration with hooks, commands, agents, and multi-provider profiles.

## Quick Start

```bash
git clone https://github.com/JNK234/dotclaude.git
cd dotclaude
./install.sh

# Add to ~/.zshrc or ~/.bashrc:
source ~/.claude/scripts/profile-switcher.sh
```

## Structure

```
~/.claude/
├── settings.json           # Main settings
├── CLAUDE.md               # Development guidelines
├── statusline-script.sh    # Custom status bar
├── hooks/
│   ├── pre_tool_use/       # Safety guards
│   ├── post_tool_use/      # Auto-format + linting
│   └── notification/       # Audio alerts
├── commands/               # Slash commands
├── agents/                 # Sub-agents
├── profiles/               # Provider profiles
└── scripts/                # Shell utilities
```

## Hooks

| Hook | Purpose |
|------|---------|
| safety_guard.py | Blocks dangerous shell commands |
| context_validator.py | Validates file paths and operations |
| auto_format.py | Auto-formats code after edits |
| linter_check.py | Runs linters and reports errors |
| voice_notify.py | Audio alerts when input needed |

## Commands

| Command | Description |
|---------|-------------|
| /plan | Create implementation plans |
| /brainstorm | Interactive brainstorming with research |
| /implement | TDD-based implementation |
| /create-spec | Interview-based spec creation |
| /commit-push | Review, commit, and push |

## Agents

| Agent | Description |
|-------|-------------|
| meta-agent | Creates new sub-agent configurations |
| code-quality-analyzer | Identifies code quality issues |
| codebase-deep-analyzer | Deep codebase analysis |

## Profile Switching

```bash
use-claude        # Default Anthropic Claude
use-openrouter    # OpenRouter (400+ models)
use-minimax       # MiniMax M2
use-kimi          # Kimi (Moonshot AI)
use-glm           # GLM (Zhipu AI)
claude-profile    # Show current profile
claude-profiles   # List all profiles
```

## Provider Setup

Each provider needs API key configuration:

```bash
# 1. Copy template
cp ~/.claude/profiles/openrouter.json.template ~/.claude/profiles/openrouter.json

# 2. Edit and add your API key
# Replace YOUR_API_KEY_HERE with actual key

# 3. Switch profile
use-openrouter
```

**Available providers:**
- `openrouter.json.template` - OpenRouter (claude-sonnet-4.5, claude-opus-4.1, gemini-2.0-flash)
- `minimax.json.template` - MiniMax M2
- `kimi.json.template` - Kimi (kimi-k2-thinking)
- `glm.json.template` - GLM (glm-4.7, glm-4.5-air)

## Requirements

- Claude Code CLI
- Python 3.x (for hooks)
- jq (for statusline)
- Optional: prettier, black, eslint (for formatting)
