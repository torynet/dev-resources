# Universal Claude Instructions

# Core Delegation Strategy

## Primary Approach

- **Delegate to specialized agents** for complex processes rather than storing detailed workflows
- **Keep user memory focused** on high-level preferences and environmental configurations
- **Use agents for technical expertise** and detailed documentation management

## Available Specialized Agents

### Documentation and Content

- `documentation-specialist`: Markdown quality assurance, linting, spell checking
- `object-model-documenter`: Salesforce object model documentation and formatting
- `decision-documenter`: Architecture decisions with comprehensive alternatives analysis
- `spell-checking-coordinator`: Intelligent spell checking and dictionary management

### Process Management

- `planning-coordinator`: GitHub Projects integration and TodoWrite synchronization
- `user-memory-manager`: User-level Claude memory management and organization
- `agent-manager`: Creating and managing specialized Claude Code agents, capability mapping, delegation optimization
- `session-manager`: Work session checkpoint and resumption workflow management

### Technical Configuration

- `mcp-manager`: MCP server configuration, discovery, and Windows-specific setup
- `claude-config-manager`: Claude Code configuration and tool permission management
- `notification-manager`: Context-aware notification management with scope differentiation

*Delegate complex processes to specialized agents rather than executing detailed workflows directly.*

## Delegation vs Interactive Collaboration Workflow

### Tasks TO Delegate to Subagents

**Autonomous Execution Suitable:**

- **Research tasks** without decision-making requirements (code analysis, feature discovery)
- **Documentation writing/formatting** with clear specifications and style guides
- **Systematic analysis** that doesn't require judgment calls (pattern identification, data extraction)
- **Technical investigation** with defined scope (dependency analysis, configuration assessment)
- **Content generation** following established templates and standards

### Tasks for Interactive Collaboration

**Real-time User Input Required:**

- **Object model reviews** requiring design decisions and trade-off evaluations
- **Architecture choices** with multiple viable options requiring user input
- **Feature specification validation** where judgment calls are needed
- **Planning and prioritization** requiring business context and user preferences
- **Any task requiring iterative feedback** or real-time decision-making

### Key Rationale

**Subagents operate autonomously** and cannot interact with the user during execution. This makes them:

- **Excellent** for well-defined, systematic work with clear success criteria
- **Inappropriate** for collaborative processes requiring user judgment, feedback, or decision-making

# Development Environment Preferences

## Platform Configuration

- **Primary Development Drive**: D:\ (Windows Dev Drive) - use for all development work, repositories, and project files
- **Shell Preference**: PowerShell commands and syntax by default
- **Line Endings**: Always use LF line endings for all files

## Workflow Preferences

- **Notifications**: Send notification after working >2 minutes when task finished or input needed
- **File Creation**: NEVER create files unless absolutely necessary; ALWAYS prefer editing existing files
- **Documentation**: NEVER proactively create documentation files unless explicitly requested

# Domain-Specific Preferences

## MCP Server Management

- **Configuration**: Delegate Windows-specific MCP setup to `mcp-manager` agent
- **Discovery**: Delegate MCP server search and capability assessment to `mcp-manager` agent

## Salesforce Development

- **Basic Naming**: PascalCase, avoid underscores except `__c`, `__r`
- **Detailed Standards**: Delegate to `object-model-documenter` agent for documentation formatting
- **Object Work**: Always delegate Salesforce object creation and field definitions to specialized agents

## Software Project Design

- **Process Reference**: D:\software-project-design-process.md contains comprehensive 6-phase methodology
- **Detailed Execution**: Delegate complex design processes to specialized agents
