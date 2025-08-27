# Claude Code Agent Ecosystem Documentation

This document provides a comprehensive overview of the Claude Code agent ecosystem, designed for human understanding and practical use.

## Architecture Overview

The agent ecosystem uses a **simple delegation architecture** where the primary Claude instance coordinates all work:

```
┌─────────────────────────────────────────┐
│ Primary Claude (Orchestrator/Delegator) │
│ • Central coordinator and decision maker│
│ • Delegates to appropriate agents       │
│ • Makes all sequencing decisions        │
│ • Only entity that calls agents         │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│ Specialized Agents (14 specialists)     │
│ • Domain expertise and capabilities     │
│ • NEVER call other agents               │
│ • Return results to primary Claude      │
│ • Complete isolation prevents loops     │
└─────────────────────────────────────────┘
```

**Key Safety Features**: 
- **Agent Isolation**: All agents are completely isolated and cannot call other agents
- **Single Delegation Point**: Only primary Claude can delegate to agents
- **Loop Prevention**: Mathematical impossibility of circular calls
- **Standardized Logging**: All agents log their activities for debugging

## Agent Inventory

### Primary Orchestrator
- **Primary Claude**: You! The central coordinator that makes all delegation decisions and sequences work across the ecosystem.

### Specialized Agents

#### Software Development Agents
*These agents help with actual software development work - the primary job you want to accomplish.*

- **`decision-documenter`**: Creates comprehensive architecture decision records
  - Capabilities: Decision documentation, alternatives analysis, rationale capture
  - Use when: Recording technical decisions, architectural choices, design documentation

- **`object-model-documenter`**: Salesforce object model documentation specialist
  - Capabilities: Object documentation, field tables, Salesforce-specific formatting
  - Use when: Creating/updating Salesforce object documentation

- **`object-model-reviewer`**: Systematic Salesforce object model analysis and review
  - Capabilities: Object model analysis, field validation, relationship verification
  - Use when: Reviewing existing object models, validation processes

- **`planning-coordinator`**: Strategic planning with mandatory GitHub Projects integration
  - Capabilities: Task creation, milestone tracking, GitHub Projects sync
  - Use when: Project planning, task coordination, progress tracking

#### Claude Ecosystem Management Agents
*These agents manage Claude Code itself - they keep the system running smoothly but aren't directly part of your software development work.*

- **`agent-manager`**: Creates and manages the agent ecosystem itself
  - Capabilities: Agent creation, modification, architecture compliance
  - Use when: Creating new agents, updating agent definitions, ecosystem maintenance

- **`claude-config-manager`**: Manages Claude Code configuration and permissions
  - Capabilities: Tool permissions, user/project settings, configuration optimization
  - Use when: Setting up Claude Code, managing permissions, configuration issues

- **`claude-problem-solver`**: Analyzes and resolves Claude Code errors and system problems
  - Capabilities: Error diagnosis, root cause analysis, solution development
  - Use when: Command failures, tool errors, system troubleshooting

- **`instruction-compliance-checker`**: Validates work against all user instructions and policies
  - Capabilities: Comprehensive compliance verification, violation detection, remediation
  - Use when: Before completing major work, ensuring policy compliance

- **`session-manager`**: Work session checkpoint and resumption (self-bootstrapping)
  - Capabilities: Session state capture, git operations, project context restoration
  - Use when: Checkpointing work, resuming sessions, work continuity

- **`user-memory-manager`**: Manages user-level Claude memories and organization
  - Capabilities: CLAUDE.md management, memory organization, cross-project insights
  - Use when: Updating user memories, organizing knowledge, preference management

- **`user-config-manager`**: Version control for user-level configurations with git
  - Capabilities: Git commits, GitHub pushes, configuration backup, change management
  - Use when: Committing user-level config changes, backing up configurations

- **`mcp-manager`**: MCP server configuration, discovery, and Windows-specific setup
  - Capabilities: MCP troubleshooting, server discovery, Windows compatibility fixes
  - Use when: MCP server issues, discovering new servers, Windows setup problems

- **`documentation-specialist`**: Complete document quality service (formatting + spell checking)
  - Capabilities: Markdown formatting, linting, spell checking, structure consistency
  - Use when: Creating/updating documentation, ensuring markdown quality

- **`file-analyzer`**: File content extraction and summarization for context optimization
  - Capabilities: File analysis, content summarization, pattern identification
  - Use when: Analyzing large files, extracting key information, reducing context usage

- **`code-analyzer`**: Code analysis, logic tracing, bug research, vulnerability detection
  - Capabilities: Code review, bug detection, logic flow analysis, security analysis
  - Use when: Code quality review, debugging, security analysis

- **`test-runner`**: Test execution and result analysis with full output capture
  - Capabilities: Test execution, result analysis, failure diagnosis
  - Use when: Running tests, validating code changes, debugging test failures

## How to Use the Ecosystem

### For Users

**Starting Work**: Just work with Primary Claude as normal. The orchestrator will automatically:
- Analyze your request
- Choose appropriate specialists
- Coordinate the work
- Ensure quality and compliance

**Common Patterns**:

*Software Development Work:*
- Object documentation → `object-model-documenter` → `documentation-specialist` (for quality)
- Project planning → `planning-coordinator` (with GitHub Projects sync)
- Technical decisions → `decision-documenter` → `documentation-specialist` (for quality)

*Claude Ecosystem Management:*
- Work validation → `instruction-compliance-checker` (before completion)
- Configuration changes → `claude-config-manager` → `user-config-manager` (for commits)
- Problem solving → `claude-problem-solver` (processes queue, calls services)
- Agent development → `agent-manager` → `user-config-manager` (for commits)
- Session management → `session-manager` (checkpoint/resume)

### For Primary Claude (Orchestrator/Delegator)

**Delegation Strategy**:
1. Analyze user request and requirements
2. Identify which specialized agent(s) can fulfill the task
3. Call agents using `Task(agent-name)` with detailed prompts
4. Agents work in complete isolation - no agent-to-agent calls
5. Evaluate agent response and recommendations
6. Decide next agent based on results
7. Run compliance checking before completion
8. Offer problem queue processing if problems exist

**Standard Patterns**:

*For Software Development:*
- Use `decision-documenter` for architectural choices and technical decisions
- Use `object-model-documenter` and `object-model-reviewer` for Salesforce work
- Use `planning-coordinator` for project planning and GitHub Projects integration
- Use `test-runner` for test execution and validation
- Use `code-analyzer` for code review and bug detection

*For Claude Ecosystem Management:*
- Always run `instruction-compliance-checker` before marking significant work complete
- Use direct notification MCP server for completion notifications
- Check `D:\problem-queue.md` after task completion
- Use `session-manager` for checkpoint/resume operations
- Use `claude-problem-solver` to process problem queues
- Use `user-config-manager` to commit ecosystem changes
- Use `file-analyzer` to analyze large files and reduce context usage

## Agent Locations

### User-Level Agents (Default)
**Location**: `C:\Users\telar\.claude\agents\`
**Benefits**: Available across all projects, persistent across project switches
**Contains**: All 16 specialized agents with standardized logging

### Project-Level Agents (When Needed)
**Location**: `[project]\.claude\agents\`
**Benefits**: Project-specific context, isolated from other projects
**Example**: Storacle project has specialized `session-manager` and `planning-coordinator` with GitHub Projects integration

## Safety Features

### Crash Prevention
1. **Agent Isolation**: Complete agent isolation prevents circular calls
2. **Single Delegation Point**: Only primary Claude can call agents
3. **Timeout Protection**: All external commands include timeout parameters
4. **Problem Queue**: Non-blocking error handling at `D:\problem-queue.md`
5. **Graceful Degradation**: Agents continue working despite individual tool failures
6. **Standardized Logging**: All agents log activities to `${DEV}claude-agent.log`

### Quality Assurance
1. **Compliance Checking**: Mandatory validation against all user instructions
2. **Documentation Quality**: Context-aware spell checking with project dictionaries
3. **Version Control**: All user-level configuration changes backed up to GitHub
4. **Architecture Compliance**: All agents follow isolation requirements
5. **Markdown Quality**: Comprehensive linting and formatting standards

## Troubleshooting

### If Claude Code Crashes
1. Agent isolation should prevent this, but if it happens:
2. Check `D:\problem-queue.md` for any queued problems
3. Run `claude-problem-solver` to process the queue
4. Review recent agent activity in `${DEV}claude-agent.log`

### If Agents Aren't Working
1. Check agent isolation requirements and delegation rules
2. Verify timeout protection is included in agent definitions
3. Ensure problem queue integration is working
4. Use `agent-manager` to validate agent compliance
5. Check agent activity logs for error patterns

### If Tools Hang or Timeout
1. All agents include comprehensive timeout protection
2. Commands will automatically timeout and queue problems
3. Alternative solutions will be attempted
4. Problems are documented for permanent resolution

## Development and Maintenance

### Creating New Agents
1. Use `agent-manager` to create new agents
2. Include agent isolation admonition
3. Include mandatory timeout protection
4. Add problem queue integration
5. Add standardized logging
6. Follow agent isolation principles

### Updating Existing Agents
1. Maintain agent isolation restrictions
2. Preserve timeout protection patterns
3. Update service integration as needed
4. Test delegation patterns
5. Ensure logging is included
6. Commit changes via `user-config-manager`

### Ecosystem Health
1. Regular compliance audits via `instruction-compliance-checker`
2. Problem queue monitoring and resolution
3. Agent architecture compliance verification
4. Performance and reliability monitoring

## Files and Documentation

### Key Files
- `D:\agentStandards.md`: Development standards and requirements
- `D:\problem-queue.md`: Central problem tracking for later resolution
- `D:\claude-agent.log`: Centralized agent activity logging
- `C:\Users\telar\.claude\CLAUDE.md`: User memory and delegation instructions

### Agent Definitions
- User-level: `C:\Users\telar\.claude\agents\*.md`
- Project-level: `[project]\.claude\agents\*.md` (when needed)

### Version Control
- User config: `torynet/claude-config` repository
- Global docs: `torynet/dev-resources` repository  
- Project-specific: Individual project repositories

## Success Metrics

The agent ecosystem is working correctly when:
- ✅ No Claude Code crashes from circular agent calls
- ✅ All external commands complete or timeout gracefully
- ✅ Problems are queued and resolved systematically
- ✅ Work quality meets all compliance requirements
- ✅ Agent coordination is transparent and efficient
- ✅ Configuration changes are automatically backed up

---

**System Status**: Fully operational with agent isolation, timeout protection, standardized logging, and quality assurance. All 16 agents comply with isolation requirements and safety patterns.