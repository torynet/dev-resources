# Agent Standards and Shared Behaviors

This document defines the standard behaviors, patterns, and requirements that apply to all Claude Code agents in the ecosystem.

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
3. **Core Responsibilities** section with specific capabilities
4. **Integration Points** section with other agent coordination
5. **Quality Standards** section with validation requirements

### Optional but Recommended Sections

- **Workflows** for complex processes
- **Examples** for usage patterns
- **Troubleshooting** for common issues
- **Configuration** for agent-specific settings

## Error Handling Standards

### Universal Error Reporting

All agents must include a "Claude Problem Solver Integration" section with these requirements:

```markdown
### Claude Problem Solver Integration

- **Error Reporting**: When encountering errors, command failures, or tool issues while working, delegate error analysis to claude-problem-solver via Task tool while continuing to attempt alternative solutions
- **Problem Documentation**: Provide complete error context including specific commands that failed, error messages, and environmental details
- **Continue Working**: Always continue attempting alternative approaches - error reporting should not stop work progress
- **Pattern Recognition**: Report recurring issues to help develop permanent prevention strategies
```

### Error Reporting Behavior

- **Continue Working**: Never stop work due to errors - always try alternative approaches
- **Report While Working**: Delegate errors to claude-problem-solver simultaneously with attempting fixes
- **Complete Context**: Include exact commands, error messages, and environmental details
- **Pattern Building**: Help build institutional knowledge for permanent problem prevention

## Quality Assurance Standards

### Documentation Quality

All agents must include and follow these quality standards:

```markdown
## Quality Standards

- Always run `markdownlint --fix *.md` after editing
- Always run `npx cspell *.md` for spell checking
- If spell checking issues found, delegate to spell-checking-coordinator agent via Task tool
- Remove trailing spaces and multiple consecutive blank lines
- Ensure final line terminators in all markdown files
- Use LF line endings consistently
- Validate markdown syntax and structure
```

### Spell Checking Integration

All agents that create or edit documentation must include:

```markdown
### Spell Checking Coordinator Integration

- **Unknown Word Handling**: Delegate spell checking of created/edited content to spell-checking-coordinator via Task tool
- **Technical Term Validation**: Use spell-checking-coordinator for domain-specific terminology validation
- **Dictionary Management**: Coordinate with spell-checking-coordinator for term categorization
- **Quality Standards**: Ensure all documentation passes spell checking through spell-checking-coordinator
```

## Notification Standards

### Work Completion Notifications

Agents performing work that takes >30 seconds must include:

```markdown
### Notification Manager Integration

- **Completion Notifications**: Delegate to notification-manager when completing work that takes >30 seconds
- **Use notification type**: "[appropriate_type]" for specific agent operations
- **Provide context**: Include details about work completed and results achieved
- **Example delegation**: "[Agent type] work complete - [specific accomplishments]"
```

### Notification Types by Agent Category

- **Documentation agents**: "documentation_task"
- **Configuration agents**: "configuration_task"
- **Analysis agents**: "analysis_task"
- **Management agents**: "management_task"
- **Problem resolution**: "problem_resolution"
- **General agent work**: "agent_subtask"

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

## Integration Standards

### Required Agent Integrations

All agents must integrate with these core agents where applicable:

#### Documentation Specialist Integration
```markdown
- **Documentation Quality**: Delegate documentation formatting and quality assurance to documentation-specialist via Task tool
- **Content Structure**: Use documentation-specialist for complex document organization
- **Cross-Reference Validation**: Delegate link validation and document consistency to documentation-specialist
```

#### User Memory Manager Integration
```markdown
- **Pattern Storage**: Delegate cross-project insights and successful patterns to user-memory-manager via Task tool
- **Configuration Preferences**: Store user preferences and successful approaches in user-level memory
- **Cross-Project Learning**: Use user-memory-manager for insights that apply across projects
```

### Delegation Patterns

#### Task Tool Usage
- Use Task tool for agent-to-agent delegation
- Provide clear, actionable delegation prompts
- Include complete context for the receiving agent

#### Integration Timing
- **Real-time coordination**: For immediate assistance needs
- **Post-completion delegation**: For documentation, notifications, and memory storage
- **Error reporting**: Immediate delegation while continuing work

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

1. **Standards Enforcement**: Ensure all new and updated agents comply with standards
2. **Standards Updates**: Update this document when new patterns emerge
3. **Compatibility Audits**: Regularly check agent compliance with current standards
4. **Evolution Management**: Guide agent ecosystem development following standards

### Standards Update Process

When updating these standards:

1. **Impact Analysis**: Assess how changes affect existing agents
2. **Migration Planning**: Plan updates for non-compliant agents
3. **Documentation**: Update this standards document
4. **Implementation**: Apply changes systematically across agent ecosystem

### Compliance Monitoring

Regular audits should verify:

- All agents follow YAML frontmatter standards
- Error reporting integration is present and correct
- Quality assurance standards are implemented
- Integration patterns follow current best practices
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