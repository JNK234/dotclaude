# Claude Code Configuration

Personal configuration for Claude Code CLI with hooks, commands, agents, and multi-provider profiles.

## Quick Start

```bash
# Clone and install
git clone https://github.com/YOUR_USERNAME/claude-code-config.git
cd claude-code-config
./install.sh

# Enable profile switching (add to ~/.zshrc)
source ~/.claude/scripts/profile-switcher.sh
```

## Structure

```
~/.claude/
├── settings.json           # Main settings (hooks, plugins, statusline)
├── CLAUDE.md               # Development guidelines
├── statusline-script.sh    # Custom status bar
├── hooks/
│   ├── pre_tool_use/       # Safety guards (run before commands)
│   ├── post_tool_use/      # Auto-format + linting (run after edits)
│   └── notification/       # Audio alerts
├── commands/               # Slash commands (/plan, /brainstorm, /implement)
├── agents/                 # Sub-agents (meta-agent, code-quality-analyzer)
├── profiles/               # Provider profiles (claude, openrouter)
└── scripts/                # Shell utilities
```

## Features

### Hooks

| Hook | Location | Purpose |
|------|----------|---------|
| safety_guard.py | pre_tool_use | Blocks dangerous shell commands |
| context_validator.py | pre_tool_use | Validates file paths and operations |
| auto_format.py | post_tool_use | Auto-formats code after edits |
| linter_check.py | post_tool_use | Runs linters and reports errors |
| voice_notify.py | notification | Audio alerts when input needed |

### Commands

| Command | Description |
|---------|-------------|
| /plan | Create implementation plans from ideas |
| /brainstorm | Interactive brainstorming with research |
| /implement | TDD-based implementation from plans |

### Agents

| Agent | Description |
|-------|-------------|
| meta-agent | Creates new sub-agent configurations |
| code-quality-analyzer | Identifies code quality issues |

### Profile Switching

```bash
use-claude        # Default Anthropic Claude
use-openrouter    # OpenRouter (400+ models)
claude-profile    # Show current profile
claude-profiles   # List all profiles
claude-reset      # Reset to defaults
```

## OpenRouter Setup

1. Copy template: `cp ~/.claude/profiles/openrouter.json.template ~/.claude/profiles/openrouter.json`
2. Add your API key to the file
3. Run `use-openrouter`

## Configuration

### settings.json

Key settings:
- `hooks`: PreToolUse, PostToolUse, Notification handlers
- `statusLine`: Custom status bar command
- `enabledPlugins`: taskmaster, superpowers
- `permissions`: bypassPermissions mode

### CLAUDE.md

Development guidelines including:
- Challenger operating mode (Gate: GO/NO-GO)
- Code quality standards
- Commit message guidelines
- Task management practices

## Requirements

- Claude Code CLI
- Python 3.x (for hooks)
- jq (for statusline)
- Optional: prettier, black, eslint (for formatting)

## License

MIT
