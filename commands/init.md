# Initialize Claude Code project

Usage: /init [--type auto|python|js|go|rust]

1. Run standard `claude init` command to scan codebase and generate CLAUDE.md
2. Auto-detect project type if not specified
3. Create basic project structure documentation
4. Set up .gitignore entries for Claude-specific files

Options:
- --type: Specify project type (auto-detects if not provided)

This is the standard Claude Code initialization. For advanced setup with directories, hooks, and MCP servers, use `/setup` instead.