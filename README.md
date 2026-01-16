# dotclaude

Personal Claude Code configuration with hooks, commands, agents, and multi-provider profiles.

## Quick Start

```bash
git clone https://github.com/JNK234/dotclaude.git
cd dotclaude
./install.sh
# Restart terminal - done!
```

The installer automatically adds profile switching to your shell config.

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
| `safety_guard.py` | Blocks dangerous shell commands (rm -rf /, fork bombs, etc.) |
| `context_validator.py` | Validates file paths, blocks system file edits |
| `auto_format.py` | Auto-formats code after edits (prettier, black, gofmt) |
| `linter_check.py` | Runs linters and reports errors (eslint, flake8, mypy) |
| `voice_notify.py` | Audio alerts when Claude needs input |

## Commands

| Command | Description |
|---------|-------------|
| `/plan` | Create detailed implementation plans from ideas. Analyzes codebase, asks clarifying questions, generates task breakdown with tech stack decisions. |
| `/brainstorm` | Interactive brainstorming with web research, deep thinking, and multi-model consensus. Saves organized ideas to file. |
| `/implement` | TDD-based implementation from plan files. Generates tests first (RED), implements (GREEN), refactors, commits. |
| `/create-spec` | Interview-based spec creation. Asks in-depth questions about technical, UI/UX, tradeoffs, then writes spec file. |
| `/commit-push` | Review changes, write conventional commit message (no AI attribution), push to current branch. |
| `/document` | Generate human-readable documentation focusing on intent and functionality, not just code structure. |
| `/prime` | Load context for new session by analyzing codebase structure, README, and recent git history. |
| `/init` | Initialize Claude Code project - scans codebase and generates CLAUDE.md. |
| `/meta-command` | Create new custom slash commands from requirements file. |

## Agents

| Agent | Description |
|-------|-------------|
| `meta-agent` | Creates new sub-agent configurations from descriptions |
| `code-quality-analyzer` | Identifies redundant code, dead code, unused elements, breaking flows |
| `codebase-deep-analyzer` | Deep codebase analysis and current state reporting |

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

| Provider | Template | Models |
|----------|----------|--------|
| OpenRouter | `openrouter.json.template` | claude-sonnet-4.5, claude-opus-4.1, gemini-2.0-flash |
| MiniMax | `minimax.json.template` | MiniMax-M2 |
| Kimi | `kimi.json.template` | kimi-k2-thinking, kimi-k2-thinking-turbo |
| GLM | `glm.json.template` | glm-4.7, glm-4.5-air |

## Requirements

- Claude Code CLI
- Python 3.x (for hooks)
- jq (for statusline)
- Optional: prettier, black, eslint (for auto-formatting)
