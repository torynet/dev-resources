# Claude Tools Inventory

## User-Level Agents

### Documentation and Content
- **documentation-specialist**: Markdown quality assurance, linting, spell checking
- **object-model-documenter**: Salesforce object model documentation and formatting
- **decision-documenter**: Architecture decisions with comprehensive alternatives analysis
- **spell-checking-coordinator**: Intelligent spell checking and dictionary management

### Process Management
- **planning-coordinator**: GitHub Projects integration and TodoWrite synchronization
- **user-memory-manager**: User-level Claude memory management and organization
- **agent-manager**: Creating and managing specialized Claude Code agents, capability mapping, delegation optimization
- **session-manager**: Work session checkpoint and resumption workflow management
- **user-config-manager**: Version control management for user-level configurations, git commits and GitHub pushes

### Technical Configuration
- **mcp-manager**: MCP server configuration, discovery, and Windows-specific setup
- **claude-config-manager**: Claude Code configuration and tool permission management
- **notification-manager**: Context-aware notification management with scope differentiation

### Problem Analysis and Resolution
- **claude-problem-solver**: Error analysis, root cause diagnosis, solution development, and permanent problem prevention

### Domain-Specific
- **object-model-reviewer**: Salesforce object model analysis and design review

### Development and Testing
- **test-agent**: Basic agent for testing and development purposes

## MCP Servers

### User-Level MCP Servers

- **notion**: Official Notion MCP server for workspace integration
  - Package: `@notionhq/notion-mcp-server`
  - Purpose: Connect to Notion workspace for reading/writing pages and databases
  - Authentication: Uses `NOTION_API_TOKEN` environment variable

- **github**: Official GitHub MCP server for repository management
  - Package: `@modelcontextprotocol/server-github`
  - Purpose: GitHub repository and project management integration
  - Authentication: Uses `GITHUB_TOKEN` environment variable

- **notifications**: Claude Code notification MCP for OS-level alerts
  - Package: `claude-code-notify-mcp`
  - Purpose: Send desktop notifications for task completion per user preferences
  - Features: Customizable sounds and cross-platform notifications