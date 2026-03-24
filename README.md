# dotclaude

Personal Claude Code configuration with hooks, commands, skills, agents, plugins, and multi-provider profiles.

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
│   ├── notification/       # Audio alerts
│   ├── session/            # Session lifecycle
│   └── stop/               # Session completion logging
├── commands/               # Slash commands
├── skills/                 # Reusable skill definitions
├── agents/                 # Sub-agents
├── profiles/               # Provider profiles
└── scripts/                # Shell utilities
```

## Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| `safety_guard.py` | PreToolUse | Blocks dangerous shell commands (rm -rf /, fork bombs, etc.) |
| `context_validator.py` | PreToolUse | Validates file paths, blocks system file edits |
| `auto_format.py` | PostToolUse | Auto-formats code after edits (prettier, black, gofmt) |
| `linter_check.py` | PostToolUse | Runs linters and reports errors (eslint, flake8, mypy) |
| `voice_notify.py` | Notification | Audio alerts when Claude needs input |
| `session_start.py` | SessionStart | Loads project context (git branch, recent commits, project type) |
| `pre_compact.py` | PreCompact | Saves conversation context before compacting |
| `conversation_log.py` | Stop | Conversation logging on session end |
| `check_sessions.py` | Session | Lists active and archived sessions |
| `session_logger.py` | Stop | Logs session completion with summary reports |

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
| `/all-tools` | List all available tools in system prompt with typescript signatures. |
| `/research-papers` | Deep-decode research papers into Obsidian notes using Literature Template + Feynman format. |
| `/ccl:weekly-report` | Generate weekly progress report from git history for CCL project. |
| `/new-raindrop-app` | Create a new Raindrop application from scratch. |
| `/reattach-raindrop-session` | Reattach to an existing Raindrop development session. |
| `/update-raindrop-app` | Add features to an existing Raindrop application. |

## Skills

| Skill | Description |
|-------|-------------|
| `apply-job` | End-to-end job application workflow: fetch JD, research company, assess fit, draft answers, log to Obsidian. |
| `ccl-demo-builder` | Build NetLogo LLM extension demos from research papers and idea specs. |
| `github-ops` | Full GitHub operations via gh CLI (PRs, issues, repos, workflows, releases, secrets). |
| `google-adk-agent-builder` | Build AI agents with Google ADK Python — agent design, orchestration, state management. |
| `netlogo-dev` | NetLogo 7.x extension development, .nlogox format, SBT builds, testing. |
| `obsidian-vault` | Full Obsidian vault management via CLI — CRUD, search, frontmatter, daily notes. |
| `research-papers` | Deep-decode papers into Obsidian notes with Feynman + Technical format. |
| `tailor-resume` | Tailor LaTeX resume for specific job descriptions with ATS keyword optimization. |
| `twitter-copywriting-skill` | Twitter/X copywriting with viral frameworks, engagement templates, and examples. |

## Agents

| Agent | Description |
|-------|-------------|
| `meta-agent` | Creates new sub-agent configurations from descriptions |
| `code-quality-analyzer` | Identifies redundant code, dead code, unused elements, breaking flows |
| `codebase-deep-analyzer` | Deep codebase analysis and current state reporting |

## Scripts

| Script | Description |
|--------|-------------|
| `profile-switcher.sh` | Shell aliases for switching between provider profiles |
| `claude-parallel` | Launch multiple Claude instances in parallel via tmux |
| `claude-worktree` | Create git worktrees for isolated parallel Claude development |
| `parallel.sh` | Claude Squad - tmux-based parallel instance manager |
| `worktree.sh` | Git worktree automation with config copying and terminal launching |
| `mcp_setup.sh` | Interactive MCP server setup (filesystem, sequential, playwright, context7, etc.) |

## Plugins

Configured via `enabledPlugins` in settings.json:

| Plugin | Status |
|--------|--------|
| `document-skills@anthropic-agent-skills` | Enabled |
| `superpowers@claude-plugins-official` | Enabled |
| `code-simplifier@claude-plugins-official` | Enabled |
| `code-review@claude-code-plugins` | Enabled |

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
- Optional: tmux (for parallel instances)
- Optional: tectonic (for resume compilation)
