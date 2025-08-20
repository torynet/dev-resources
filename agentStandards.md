# Agent Standards and Shared Behaviors

This document defines the standard behaviors, patterns, and requirements that apply to all Claude Code agents in the three-tier architecture ecosystem.

## Three-Tier Architecture Overview

All agents operate within a three-tier architecture designed to prevent circular calls and ensure system stability:

### Tier 1: Orchestrator (Primary Claude)
- **Role**: Central coordinator and decision maker
- **Delegation**: Can call any agent based on task requirements
- **Responsibility**: Makes all sequencing decisions beyond Tier 3 service calls

### Tier 2: Domain Agents
- **Role**: Specialized expertise in specific domains
- **Delegation**: Can ONLY call Tier 3 service agents
- **Examples**: object-model-documenter, claude-problem-solver, planning-coordinator
- **Restriction**: CANNOT call other Tier 2 agents - must return recommendations to orchestrator

### Tier 3: Service Agents
- **Role**: Pure utility services with no delegation capabilities
- **Delegation**: CANNOT call any other agents - must queue problems instead
- **Examples**: documentation-specialist, notification-manager
- **Guarantee**: Terminal nodes in all delegation chains - mathematically prevents loops

## YAML Frontmatter Standards

### Required Fields

All agent files must include these YAML frontmatter fields:

```yaml
---
name: agent-name
description: "Comprehensive description with trigger keywords for automatic delegation"
tools: Tool1, Tool2, Tool3
---
```

### Field Requirements

- **name**: Unique identifier in kebab-case (e.g., `claude-problem-solver`)
- **description**: Must include trigger keywords that help main Claude recognize when to delegate
- **tools**: Specific list of tools the agent needs access to (not generic "all tools")

## Agent Structure Standards

### Required Sections

All agents must include these core sections:

1. **Agent Title** (# Agent Name)
2. **Brief Introduction** explaining agent purpose
3. **Agent Tier Classification** section defining tier level and delegation rules
4. **Critical Safety Requirements** section with timeout protection
5. **Core Responsibilities** section with specific capabilities
6. **Problem Queue Integration** section for error handling
7. **Service Integration** section for Tier 3 service usage (Tier 2 agents only)

### Optional but Recommended Sections

- **Workflows** for complex processes
- **Examples** for usage patterns
- **Troubleshooting** for common issues
- **Configuration** for agent-specific settings

## Critical Safety Requirements

### Mandatory Timeout Protection

All agents must include a "Critical Safety Requirements" section with comprehensive timeout protection:

```markdown
## Critical Safety Requirements

### Timeout Protection
- **ALL external commands MUST include timeout parameter**
- **ALL [tool-specific] operations require [X]-second timeout**
- **ALL file operations require appropriate timeouts**

### Safe Command Patterns
```markdown
# For external commands
Bash(command, timeout=30000, description="Command description with timeout")
mcp__tool__operation(timeout=45000, description="MCP operation with timeout")
Tool(parameters, timeout=15000, description="Tool operation with timeout")
```

### Tool-Specific Timeout Requirements

**Bash Commands**:
- Basic operations: 30-second timeout
- Git operations: 45-60 second timeout
- Network operations: 60-90 second timeout
- Package operations: 120-second timeout

**MCP Operations**:
- GitHub Projects: 60-second timeout
- Notifications: 30-second timeout
- File operations: 15-30 second timeout

**File Tools**:
- Read/Write: 15-second timeout
- Search operations: 30-45 second timeout

## Error Handling Standards

### Problem Queue Integration

All agents must include a "Problem Queue Integration" section:

```markdown
### Problem Queue Integration

**Problem Reporting**: When encountering issues:
- Append problems to `${DEV}problem-queue.md`
- Format: `- [ ] [timestamp] agent-name: Problem description`
- Include full context for troubleshooting
- Continue with best-effort service delivery
```

### Tier-Specific Error Handling

**Tier 2 Domain Agents**: Can delegate to claude-problem-solver via Task tool for complex error analysis

**Tier 3 Service Agents**: MUST queue problems instead of delegating - cannot call claude-problem-solver directly

### Error Reporting Behavior

- **Continue Working**: Never stop work due to errors - always try alternative approaches
- **Queue Problems**: Add issues to problem queue while continuing work
- **Complete Context**: Include exact commands, error messages, and environmental details
- **Pattern Building**: Help build institutional knowledge for permanent problem prevention

## Quality Assurance Standards

### Documentation Quality via Tier 3 Services

Tier 2 agents that create or edit documentation must use the documentation-specialist service:

```markdown
### Service Integration

### Documentation Quality
- Use Task(documentation-specialist) for formatting and quality of all documentation
- Ensure all documents meet quality standards through comprehensive processing
- Maintain consistent documentation format and structure
```

### Tier 3 Service: Documentation Specialist

The documentation-specialist provides complete document quality including:
- Markdown formatting and linting
- Comprehensive spell checking with dictionary management
- Structure consistency validation
- Quality standards enforcement

**Note**: The spell-checking-coordinator has been merged into documentation-specialist for simplified service delivery.

## Notification Standards

### Notification Service Integration

Tier 2 agents performing work that takes >30 seconds must include:

```markdown
### Notifications
- Use Task(notification-manager) for completion notifications on work >30 seconds
- Notify when critical milestones are achieved or work is completed
- Provide status updates during complex operations
```

### Notification Types

- **Agent Subtask**: "agent_subtask" for Tier 2 agent work completion
- **Task Completion**: "primary_task" for major user-requested work (orchestrator)
- **Error Alerts**: "error" for critical issues requiring attention
- **Progress Updates**: "progress" for ongoing work status

## Agent Location Standards

### User-Level vs Project-Level Placement

**Default Preference: User-Level**
- **Location**: `C:\Users\telar\.claude\agents\`
- **Benefits**: Available across all projects, persistent across project switches
- **Use Cases**: General-purpose agents, cross-project utilities, personal workflow agents

**Project-Level Usage**
- **Location**: Project `.claude\agents\` directory
- **Benefits**: Project-specific context, isolated from other projects
- **Use Cases**: Project-specific domain experts, custom project workflows
- **Requirement**: Always ask user permission before creating project-level agents

### Agent Location Decision Process

1. **Default to User-Level**: Unless specifically requested or clearly project-specific
2. **Ask Before Project-Level**: Always confirm if project-level placement is appropriate
3. **Explain Benefits**: Clarify that user-level agents work across all projects
4. **Justify Project-Level**: Only use when agent has strong project-specific context

## Three-Tier Integration Standards

### Tier 2 Agent Service Integration

Tier 2 domain agents must include service integration patterns:

#### Tier 3 Service Usage
```markdown
### Service Integration

### Documentation Quality
- Use Task(documentation-specialist) for formatting and quality of all documentation
- Ensure all documents meet quality standards
- Maintain consistent documentation format

### Notifications
- Use Task(notification-manager) for completion notifications on work >30 seconds
- Provide status updates during complex operations
```

### Delegation Rules by Tier

#### Tier 1 (Orchestrator)
- **Can call**: Any agent based on task requirements
- **Responsibility**: All sequencing decisions beyond Tier 3 service calls

#### Tier 2 (Domain Agents)
- **Can call**: ONLY Tier 3 service agents
- **Cannot call**: Other Tier 2 agents - must return recommendations to orchestrator
- **Service usage**: Task(documentation-specialist), Task(notification-manager)

#### Tier 3 (Service Agents)
- **Cannot call**: Any other agents - must queue problems to ${DEV}problem-queue.md
- **Restriction**: Terminal nodes in delegation chains

## Agent Design Principles

### Single Responsibility Principle
- Each agent should have one clear, focused purpose
- Avoid capability overlap with existing agents
- Delegate to specialists rather than duplicating functionality

### Comprehensive Descriptions
- Include trigger keywords that help main Claude recognize when to delegate
- Describe specific use cases and capabilities
- Provide clear boundaries of agent responsibility

### Tool Access Management
- Only include tools the agent actually needs
- Use specific tool names rather than generic access
- Justify tool access based on agent responsibilities

### Modular Architecture
- Support clean delegation patterns between agents
- Define clear integration points
- Maintain loose coupling between agent capabilities

## File Operations Standards

### File Editing Requirements
- Always read existing files before editing
- Preserve existing content unless specifically instructed to change it
- Use appropriate editing tools (Edit, MultiEdit) based on scope
- Validate changes after editing

### MCP Server Configuration Requirements
- **🚨 CRITICAL:** User-level MCP servers MUST be placed at ROOT LEVEL of `C:\Users\telar\.claude.json`
- **NEVER place user-level MCP servers in project sections** (like `"D:\\Tory\\repos\\storacle"`)
- **Verify placement:** mcpServers should be at same level as "numStartups", "installMethod", etc.
- **Test functionality:** Always verify MCP servers appear in `/mcp` command after installation

### File Creation Standards
- Create files only when necessary for agent function
- Use appropriate directory locations (user vs project level)
- Follow consistent naming conventions
- Include proper file headers and structure

## Agent Development Lifecycle

### Creation Process
1. **Requirements Analysis**: Understand agent scope and purpose
2. **Standards Compliance**: Apply all applicable standards from this document
3. **Integration Design**: Plan coordination with existing agents
4. **Quality Validation**: Run quality assurance checks
5. **Documentation Review**: Ensure comprehensive agent documentation

### Update Process
1. **Standards Review**: Check against current standards in this document
2. **Integration Updates**: Ensure coordination patterns are current
3. **Quality Validation**: Run updated quality assurance checks
4. **Compatibility Testing**: Verify agent works with ecosystem changes

### Deprecation Process
1. **Impact Assessment**: Identify dependent agents and workflows
2. **Migration Planning**: Plan transition to replacement capabilities
3. **Notification**: Inform users of deprecation timeline
4. **Cleanup**: Remove deprecated agents and update references

## Standards Maintenance

### Agent Manager Responsibilities

The agent-manager agent is responsible for:

1. **Standards Enforcement**: Ensure all new and updated agents comply with three-tier architecture
2. **Tier Classification**: Properly classify agents into appropriate tiers
3. **Architecture Compliance**: Validate that agents respect delegation restrictions
4. **Standards Updates**: Update this document when architecture patterns evolve
5. **Compatibility Audits**: Regularly check agent compliance with tier restrictions

### Standards Update Process

When updating these standards:

1. **Impact Analysis**: Assess how changes affect existing agents
2. **Migration Planning**: Plan updates for non-compliant agents
3. **Documentation**: Update this standards document
4. **Implementation**: Apply changes systematically across agent ecosystem

### Compliance Monitoring

Regular audits should verify:

- All agents follow YAML frontmatter standards
- Tier classification is clearly defined and correct
- Critical Safety Requirements section with timeout protection is present
- All external commands include mandatory timeout parameters
- Problem queue integration is present and correct
- Service integration patterns follow three-tier restrictions
- No circular call patterns exist in agent definitions
- Agent locations follow user-level preference guidelines

## Exception Handling

### Standards Exemptions

Some agents may have legitimate reasons to deviate from standards:

- **Legacy agents** with established patterns that work well
- **Specialized agents** with unique requirements
- **Experimental agents** testing new patterns

### Exemption Documentation

When agents don't follow standards, document:

1. **Specific deviation**: What standard is not followed
2. **Justification**: Why the deviation is necessary
3. **Impact assessment**: How deviation affects ecosystem
4. **Future plans**: Whether agent will be updated to comply

### Review Process

Exemptions should be reviewed regularly to determine:

- Whether justification still applies
- Whether standards should be updated to accommodate the pattern
- Whether agent should be updated to comply with standards
- Whether exemption can be resolved through refactoring