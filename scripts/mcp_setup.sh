#!/bin/bash
# ABOUTME: MCP (Model Context Protocol) server setup for Claude Code and Claude Desktop
# ABOUTME: Configures user-scope MCPs for Claude Code and writes Desktop config for Claude Desktop

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

echo -e "${BLUE}Claude MCP Server Setup${NC}"
echo "================================"
echo ""
echo -e "${GRAY}Claude Code MCPs  → user-scope in ~/.claude.json${NC}"
echo -e "${GRAY}Claude Desktop MCPs → ~/Library/Application Support/Claude/claude_desktop_config.json${NC}"
echo ""

command_exists() {
    command -v "$1" &> /dev/null
}

check_prerequisites() {
    echo -e "${YELLOW}Checking prerequisites...${NC}"

    if ! command_exists node; then
        echo -e "${RED}Node.js not found. Please install Node.js first.${NC}"
        exit 1
    fi

    if ! command_exists npx; then
        echo -e "${RED}npx not found. Please install npx first.${NC}"
        exit 1
    fi

    if ! command_exists claude; then
        echo -e "${RED}Claude Code not found. Please install Claude Code first.${NC}"
        exit 1
    fi

    echo -e "${GREEN}All prerequisites met${NC}"
    echo ""
}

# Helper: add a server to user-scope, skip if already exists
add_user_server() {
    local name="$1"
    shift
    if claude mcp get "$name" -s user &>/dev/null 2>&1; then
        echo -e "${GRAY}  $name already configured - skipping${NC}"
    else
        claude mcp add -s user "$name" "$@" 2>&1 && \
            echo -e "${GREEN}  $name added${NC}" || \
            echo -e "${YELLOW}  $name failed (non-fatal)${NC}"
    fi
}

# ── Claude Code: Essential servers ──────────────────────────────────────────
setup_cc_essential() {
    echo -e "${YELLOW}[Claude Code] Setting up essential servers (user-scope)...${NC}"

    add_user_server filesystem -- npx -y @modelcontextprotocol/server-filesystem "$HOME/Developer"
    add_user_server sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking
    add_user_server context7 -- npx -y @upstash/context7-mcp@latest
    add_user_server memory -- npx -y @modelcontextprotocol/server-memory

    local zen_path="$HOME/Developer/MCPs/zen-mcp-server"
    if [[ -d "$zen_path" && -f "$zen_path/.zen_venv/bin/python" ]]; then
        add_user_server zen -- "$zen_path/.zen_venv/bin/python" "$zen_path/server.py"
    else
        echo -e "${GRAY}  zen not found at $zen_path - skipping${NC}"
    fi

    echo -e "${GREEN}Essential servers configured${NC}"
    echo ""
}

# ── Claude Code: Productivity servers ───────────────────────────────────────
setup_cc_productivity() {
    echo -e "${YELLOW}[Claude Code] Setting up productivity servers (user-scope)...${NC}"

    add_user_server obsidian -- npx -y mcp-obsidian "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain"
    add_user_server task-master-ai -- npx -y task-master-ai
    add_user_server chrome-devtools -- npx chrome-devtools-mcp@latest

    if command_exists uvx; then
        add_user_server voicemode -- uvx --refresh voice-mode
    else
        echo -e "${GRAY}  voicemode requires uvx - skipping${NC}"
    fi

    echo -e "${GREEN}Productivity servers configured${NC}"
    echo ""
}

# ── Claude Code: Cloud servers ──────────────────────────────────────────────
setup_cc_cloud() {
    echo -e "${YELLOW}[Claude Code] Setting up cloud servers (user-scope)...${NC}"

    add_user_server gcloud-mcp -- npx -y @google-cloud/gcloud-mcp
    add_user_server cloud-run-mcp -- npx -y @google-cloud/cloud-run-mcp

    if [ -n "${BRAVE_API_KEY:-}" ]; then
        claude mcp add -s user -e BRAVE_API_KEY="$BRAVE_API_KEY" brave-search -- npx -y @modelcontextprotocol/server-brave-search 2>/dev/null && \
            echo -e "${GREEN}  brave-search added${NC}" || echo -e "${GRAY}  brave-search already exists${NC}"
    else
        echo -e "${GRAY}  brave-search requires BRAVE_API_KEY - skipping${NC}"
    fi

    echo -e "${GREEN}Cloud servers configured${NC}"
    echo ""
}

# ── Claude Code: API-key servers ────────────────────────────────────────────
setup_cc_apikey() {
    echo -e "${YELLOW}[Claude Code] Setting up API-key servers (user-scope)...${NC}"

    if [ -n "${ELEVENLABS_API_KEY:-}" ]; then
        claude mcp add -s user -e ELEVENLABS_API_KEY="$ELEVENLABS_API_KEY" elevenlabs -- npx -y @angelogiacco/elevenlabs-mcp-server 2>/dev/null && \
            echo -e "${GREEN}  elevenlabs added${NC}" || echo -e "${GRAY}  elevenlabs already exists${NC}"
    else
        echo -e "${GRAY}  elevenlabs requires ELEVENLABS_API_KEY - skipping${NC}"
    fi

    if [ -n "${PERPLEXITY_API_KEY:-}" ]; then
        claude mcp add -s user -e PERPLEXITY_API_KEY="$PERPLEXITY_API_KEY" perplexity -- node "$HOME/Documents/Cline/MCP/perplexity-mcp/build/index.js" 2>/dev/null && \
            echo -e "${GREEN}  perplexity added${NC}" || echo -e "${GRAY}  perplexity already exists${NC}"
    else
        echo -e "${GRAY}  perplexity requires PERPLEXITY_API_KEY - skipping${NC}"
    fi

    add_user_server firecrawl -- npx -y firecrawl-mcp

    echo -e "${GREEN}API-key servers configured${NC}"
    echo ""
}

# ── Claude Code: Database servers ───────────────────────────────────────────
setup_cc_database() {
    echo -e "${YELLOW}[Claude Code] Setting up database servers (user-scope)...${NC}"

    if [ -n "${DATABASE_URL:-}" ] || [ -n "${POSTGRES_URL:-}" ]; then
        local db_url="${DATABASE_URL:-$POSTGRES_URL}"
        claude mcp add -s user -e DATABASE_URL="$db_url" postgres -- npx -y @modelcontextprotocol/server-postgres 2>/dev/null && \
            echo -e "${GREEN}  postgres added${NC}" || echo -e "${GRAY}  postgres already exists${NC}"
    else
        echo -e "${GRAY}  postgres requires DATABASE_URL - skipping${NC}"
    fi

    add_user_server sqlite -- npx -y @modelcontextprotocol/server-sqlite

    echo -e "${GREEN}Database servers configured${NC}"
    echo ""
}

# ── Claude Desktop: Write config ────────────────────────────────────────────
setup_desktop() {
    echo -e "${YELLOW}[Claude Desktop] Setting up Desktop MCP config...${NC}"

    if [[ ! -f "$DESKTOP_CONFIG" ]]; then
        echo -e "${RED}Claude Desktop config not found at $DESKTOP_CONFIG${NC}"
        echo -e "${GRAY}Install Claude Desktop first, then re-run this.${NC}"
        return 1
    fi

    local zen_path="$HOME/Developer/MCPs/zen-mcp-server"
    local obsidian_vault="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain"

    # Build the mcpServers object, preserving existing preferences
    local tmp_file
    tmp_file=$(mktemp)

    python3 -c "
import json, sys

config_path = '$DESKTOP_CONFIG'
with open(config_path) as f:
    config = json.load(f)

servers = {
    'zen': {
        'command': '$zen_path/.zen_venv/bin/python',
        'args': ['$zen_path/server.py']
    },
    'obsidian': {
        'command': 'npx',
        'args': ['-y', 'mcp-obsidian', '$obsidian_vault']
    },
    'sequential-thinking': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-sequential-thinking']
    },
    'cloud-run-mcp': {
        'command': 'npx',
        'args': ['-y', '@google-cloud/cloud-run-mcp']
    },
    'context7': {
        'command': 'npx',
        'args': ['-y', '@upstash/context7-mcp@latest']
    },
    'filesystem': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-filesystem', '$HOME/Developer']
    },
    'puppeteer': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-puppeteer']
    }
}

# Merge: keep existing servers not in our list (e.g. quibo, perplexity with keys)
existing = config.get('mcpServers', {})
for name, srv in existing.items():
    if name not in servers:
        servers[name] = srv

config['mcpServers'] = servers

with open('$tmp_file', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')
" 2>&1

    if [[ -f "$tmp_file" && -s "$tmp_file" ]]; then
        cp "$tmp_file" "$DESKTOP_CONFIG"
        rm "$tmp_file"
        echo -e "${GREEN}Desktop config updated at $DESKTOP_CONFIG${NC}"
    else
        echo -e "${RED}Failed to generate Desktop config${NC}"
        rm -f "$tmp_file"
        return 1
    fi
    echo ""
}

# ── Test ────────────────────────────────────────────────────────────────────
test_servers() {
    echo -e "${YELLOW}Testing Claude Code MCP server connections...${NC}"
    echo ""
    claude mcp list
    echo ""
    echo -e "${GREEN}Test complete${NC}"
}

# ── Info ────────────────────────────────────────────────────────────────────
show_info() {
    echo ""
    echo -e "${BLUE}MCP Architecture${NC}"
    echo "================================"
    echo ""
    echo -e "${YELLOW}Config locations:${NC}"
    echo "  Claude Code (user-scope):  ~/.claude.json"
    echo "  Claude Code (per-project): <project>/.mcp.json"
    echo "  Claude Desktop:            ~/Library/Application Support/Claude/claude_desktop_config.json"
    echo ""
    echo -e "${YELLOW}Scope precedence (Claude Code):${NC}"
    echo "  local (per-project private) > project (.mcp.json) > user (global)"
    echo ""
    echo -e "${YELLOW}Management commands:${NC}"
    echo "  claude mcp list                    Show all active servers"
    echo "  claude mcp get <name>              Server details and scope"
    echo "  claude mcp add --scope user ...    Add server to user-scope"
    echo "  claude mcp remove <name> -s user   Remove user-scope server"
    echo ""
    echo -e "${RED}Avoid:${NC}"
    echo "  ~/.mcp.json as global config (it's project-scope for home dir)"
    echo "  ~/.claude/claude_desktop_config.json (not read by any system)"
    echo ""
}

# ── Menu ────────────────────────────────────────────────────────────────────
show_menu() {
    echo ""
    echo -e "${BLUE}MCP Server Setup Options:${NC}"
    echo "1) Quick Setup - Essential CC servers only (recommended)"
    echo "2) Full Setup - All CC + Desktop servers"
    echo "3) Claude Code: Essential servers"
    echo "4) Claude Code: Productivity servers"
    echo "5) Claude Code: Cloud servers"
    echo "6) Claude Code: API-key servers"
    echo "7) Claude Code: Database servers"
    echo "8) Claude Desktop: Setup config"
    echo "9) Test Connections"
    echo "a) Show Architecture Info"
    echo "q) Exit"
    echo ""
}

# ── Main ────────────────────────────────────────────────────────────────────
main() {
    check_prerequisites

    case "${1:-}" in
        "--quick"|"-q")
            setup_cc_essential
            test_servers
            show_info
            exit 0
            ;;
        "--full"|"-f")
            setup_cc_essential
            setup_cc_productivity
            setup_cc_cloud
            setup_cc_apikey
            setup_cc_database
            setup_desktop
            test_servers
            show_info
            exit 0
            ;;
        "--test"|"-t")
            test_servers
            exit 0
            ;;
        "--desktop"|"-d")
            setup_desktop
            exit 0
            ;;
        "--info"|"-i")
            show_info
            exit 0
            ;;
    esac

    while true; do
        show_menu
        read -p "Select option: " choice

        case $choice in
            1) setup_cc_essential; test_servers; show_info ;;
            2) setup_cc_essential; setup_cc_productivity; setup_cc_cloud; setup_cc_apikey; setup_cc_database; setup_desktop; test_servers; show_info ;;
            3) setup_cc_essential ;;
            4) setup_cc_productivity ;;
            5) setup_cc_cloud ;;
            6) setup_cc_apikey ;;
            7) setup_cc_database ;;
            8) setup_desktop ;;
            9) test_servers ;;
            a) show_info ;;
            q) echo -e "${BLUE}Setup complete!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option.${NC}" ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"
