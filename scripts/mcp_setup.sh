#!/bin/bash
# ABOUTME: MCP (Model Context Protocol) server setup for Claude Code
# ABOUTME: Interactive setup script with essential, optional, database, and cloud server categories

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

echo -e "${BLUE}Claude Code MCP Server Setup${NC}"
echo "================================"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check prerequisites
check_prerequisites() {
    echo -e "${YELLOW}Checking prerequisites...${NC}"

    if ! command_exists node; then
        echo -e "${RED}Node.js not found. Please install Node.js first.${NC}"
        echo "Visit: https://nodejs.org/"
        exit 1
    fi

    if ! command_exists npm; then
        echo -e "${RED}npm not found. Please install npm first.${NC}"
        exit 1
    fi

    if ! command_exists npx; then
        echo -e "${RED}npx not found. Please install npx first.${NC}"
        exit 1
    fi

    if ! command_exists claude; then
        echo -e "${RED}Claude Code not found. Please install Claude Code first.${NC}"
        echo "Visit: https://claude.ai/code"
        exit 1
    fi

    echo -e "${GREEN}All prerequisites met${NC}"
    echo ""
}

# Function to setup essential MCP servers
setup_essential_servers() {
    echo -e "${YELLOW}Setting up essential MCP servers...${NC}"

    echo -e "${GRAY}Installing Filesystem MCP...${NC}"
    claude mcp add -s user filesystem -- npx -y @modelcontextprotocol/server-filesystem "$HOME/Developer" || {
        echo -e "${YELLOW}Filesystem MCP failed, trying with current directory...${NC}"
        claude mcp add -s user filesystem -- npx -y @modelcontextprotocol/server-filesystem "$(pwd)"
    }

    echo -e "${GRAY}Installing Sequential Thinking MCP...${NC}"
    claude mcp add -s user sequential -- npx -y @modelcontextprotocol/server-sequential-thinking

    echo -e "${GRAY}Installing Playwright MCP...${NC}"
    claude mcp add -s user playwright -- npx -y @executeautomation/playwright-mcp-server

    echo -e "${GRAY}Installing Context7 MCP...${NC}"
    claude mcp add -s user context7 -- npx -y @upstash/context7-mcp@latest

    echo -e "${GRAY}Installing GitHub MCP...${NC}"
    claude mcp add -s user github -- npx -y @modelcontextprotocol/server-github

    echo -e "${GRAY}Installing Memory MCP...${NC}"
    claude mcp add -s user memory -- npx -y @modelcontextprotocol/server-memory

    local zen_path="/Users/$(whoami)/Developer/MCPs/zen-mcp-server"
    if [[ -d "$zen_path" && -f "$zen_path/.zen_venv/bin/python" ]]; then
        echo -e "${GRAY}Installing Zen MCP (advanced AI collaboration)...${NC}"
        claude mcp add -s user zen -- "$zen_path/.zen_venv/bin/python" "$zen_path/server.py"
        echo -e "${GREEN}Zen MCP configured${NC}"
    else
        echo -e "${YELLOW}Zen MCP not found at $zen_path - skipping${NC}"
        echo -e "${GRAY}To install Zen: git clone https://github.com/BeehiveInnovations/zen-mcp-server.git $zen_path${NC}"
    fi

    echo -e "${GREEN}Essential MCP servers configured${NC}"
}

# Function to setup optional MCP servers
setup_optional_servers() {
    echo -e "${YELLOW}Setting up optional MCP servers...${NC}"

    echo -e "${GRAY}Installing Memory MCP...${NC}"
    claude mcp add -s user memory -- npx -y @modelcontextprotocol/server-memory || {
        echo -e "${YELLOW}Memory MCP installation failed (optional)${NC}"
    }

    echo -e "${GRAY}Installing Puppeteer MCP...${NC}"
    claude mcp add -s user puppeteer -- npx -y @modelcontextprotocol/server-puppeteer || {
        echo -e "${YELLOW}Puppeteer MCP installation failed (optional)${NC}"
    }

    echo -e "${GREEN}Optional MCP servers setup complete${NC}"
}

# Function to setup database MCP servers
setup_database_servers() {
    echo -e "${YELLOW}Setting up database MCP servers...${NC}"

    if [ -n "${DATABASE_URL:-}" ] || [ -n "${POSTGRES_URL:-}" ]; then
        echo -e "${GRAY}Installing PostgreSQL MCP...${NC}"
        local db_url="${DATABASE_URL:-$POSTGRES_URL}"
        claude mcp add -s user postgres -e DATABASE_URL="$db_url" -- npx -y @modelcontextprotocol/server-postgres
        echo -e "${GREEN}PostgreSQL MCP configured${NC}"
    else
        echo -e "${GRAY}Skipping PostgreSQL MCP (no DATABASE_URL found)${NC}"
        echo "To add later: export DATABASE_URL='your-connection-string'"
    fi

    echo -e "${GRAY}Installing SQLite MCP...${NC}"
    claude mcp add -s user sqlite -- npx -y @modelcontextprotocol/server-sqlite || {
        echo -e "${YELLOW}SQLite MCP installation failed (optional)${NC}"
    }
}

# Function to setup cloud service MCP servers
setup_cloud_services() {
    echo -e "${YELLOW}Setting up cloud service MCP servers...${NC}"

    if [ -n "${GITHUB_TOKEN:-}" ]; then
        echo -e "${GRAY}Installing GitHub MCP with authentication...${NC}"
        claude mcp add -s user github -e GITHUB_TOKEN="$GITHUB_TOKEN" -- npx -y @modelcontextprotocol/server-github
        echo -e "${GREEN}GitHub MCP configured with authentication${NC}"
    else
        echo -e "${GRAY}Installing GitHub MCP (limited functionality without token)...${NC}"
        claude mcp add -s user github -- npx -y @modelcontextprotocol/server-github
        echo -e "${YELLOW}GitHub MCP installed without token - limited functionality${NC}"
    fi

    if [ -n "${GOOGLE_DRIVE_CREDENTIALS:-}" ]; then
        echo -e "${GRAY}Installing Google Drive MCP...${NC}"
        claude mcp add -s user gdrive -e GOOGLE_DRIVE_CREDENTIALS="$GOOGLE_DRIVE_CREDENTIALS" -- npx -y @modelcontextprotocol/server-gdrive || {
            echo -e "${YELLOW}Google Drive MCP installation failed${NC}"
        }
    else
        echo -e "${GRAY}Skipping Google Drive MCP (no credentials found)${NC}"
    fi
}

# Function to test MCP servers
test_mcp_servers() {
    echo -e "${YELLOW}Testing MCP server connections...${NC}"
    echo ""
    claude mcp list
    echo ""
    echo -e "${GREEN}MCP server test complete${NC}"
}

# Function to show MCP server status and usage
show_mcp_info() {
    echo ""
    echo -e "${BLUE}MCP Servers Information${NC}"
    echo "================================"
    echo ""
    echo -e "${YELLOW}Installed Servers:${NC}"
    echo "  filesystem - File operations and directory management"
    echo "  sequential - Advanced reasoning and problem-solving"
    echo "  playwright - Web automation and browser testing"
    echo "  context7 - Documentation lookup and context retrieval"
    echo "  github - GitHub repository management and operations"
    echo "  memory - Persistent memory across sessions"
    echo "  zen - Advanced AI collaboration with multiple models"
    echo ""
    echo -e "${YELLOW}Management Commands:${NC}"
    echo "  claude mcp list - Show all servers"
    echo "  claude mcp get <name> - Get server details"
    echo "  claude mcp remove <name> - Remove a server"
    echo ""
}

# Interactive menu
show_menu() {
    echo ""
    echo -e "${BLUE}MCP Server Setup Options:${NC}"
    echo "1) Quick Setup - Essential servers only (recommended)"
    echo "2) Full Setup - All available servers"
    echo "3) Essential Servers - Core functionality"
    echo "4) Optional Servers - Additional features"
    echo "5) Database Servers - PostgreSQL, SQLite"
    echo "6) Cloud Services - GitHub, Google Drive"
    echo "7) Test Connections - Verify server health"
    echo "8) Show Information - Usage and management"
    echo "9) Exit"
    echo ""
}

# Main execution
main() {
    check_prerequisites

    case "${1:-}" in
        "--quick"|"-q")
            setup_essential_servers
            test_mcp_servers
            show_mcp_info
            exit 0
            ;;
        "--full"|"-f")
            setup_essential_servers
            setup_optional_servers
            setup_database_servers
            setup_cloud_services
            test_mcp_servers
            show_mcp_info
            exit 0
            ;;
        "--test"|"-t")
            test_mcp_servers
            exit 0
            ;;
    esac

    while true; do
        show_menu
        read -p "Select option (1-9): " choice

        case $choice in
            1) setup_essential_servers; test_mcp_servers; show_mcp_info ;;
            2) setup_essential_servers; setup_optional_servers; setup_database_servers; setup_cloud_services; test_mcp_servers; show_mcp_info ;;
            3) setup_essential_servers ;;
            4) setup_optional_servers ;;
            5) setup_database_servers ;;
            6) setup_cloud_services ;;
            7) test_mcp_servers ;;
            8) show_mcp_info ;;
            9) echo -e "${BLUE}Setup complete!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option. Please select 1-9.${NC}" ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"
