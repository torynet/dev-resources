# Orchestrator Workflows Documentation

## Overview

This document provides detailed workflows for Primary Claude operating as the central orchestrator. All agent coordination happens at the orchestrator level, with agents never calling other agents.

## Core Orchestration Patterns

### Pattern 1: Sequential Service Chain
```
User Request → Orchestrator analyzes
    ↓
Task(agent-A) → Returns results + recommendations
    ↓
Orchestrator evaluates recommendations
    ↓
Task(agent-B) based on recommendations → Returns results
    ↓
Task(agent-C) for quality checks → Returns validation
    ↓
Complete
```

### Pattern 2: Parallel Independent Tasks
```
User Request → Orchestrator identifies independent work
    ↓
Task(agent-A) for component 1
Task(agent-B) for component 2  
Task(agent-C) for component 3
    ↓
Orchestrator combines results
    ↓
Complete
```

### Pattern 3: Conditional Branching
```
User Request → Orchestrator
    ↓
Task(agent-A) → Returns results with issues
    ↓
If issues: Task(agent-B) to resolve
Else: Task(agent-C) to proceed
    ↓
Complete
```

## Standard Task Workflows

### Code Development Workflow
```python
1. User: "Create a new feature X"
2. Orchestrator: Analyze requirements
3. Task(agent-manager) if new agent needed
4. Write/Edit code directly
5. Task(documentation-specialist) for markdown quality
6. If unknown words returned:
   - Task(spell-checking-coordinator) to categorize
7. Task(instruction-compliance-checker) for validation
8. Task(notification-manager) if >2 minutes
9. Check D:\problem-queue.md
10. Offer problem resolution if needed
```

### Configuration Management Workflow
```python
1. User: "Update configuration Y"
2. Orchestrator: Identify configuration type
3. Task(claude-config-manager) for Claude settings
   OR Task(mcp-manager) for MCP servers
4. If changes affect user-level:
   - Task(user-config-manager) for git commit
5. Task(notification-manager) for completion
6. Check problem queue
```

### Problem Resolution Workflow
```python
1. Check D:\problem-queue.md for pending items
2. If problems exist:
   - "Found N problems. Run troubleshooter?"
3. If user accepts:
   - Task(claude-problem-solver) to process queue
4. If user declines:
   - Problems remain for later session
```

### Documentation Workflow
```python
1. User: "Document feature Z"
2. Orchestrator: Create/update documentation
3. Task(documentation-specialist) for quality
4. If spell issues:
   - Task(spell-checking-coordinator)
5. Task(decision-documenter) if architectural
6. Complete with quality assurance
```

## Agent-Specific Integration

### spell-checking-coordinator
**When to invoke**:
- After documentation-specialist reports unknown words
- When user explicitly requests spell checking
- After any markdown file creation/editing

**Expected response**:
- Words categorized and dictionaries updated
- Recommendations for further checking
- Problems queued if dictionary issues

### documentation-specialist
**When to invoke**:
- After creating/modifying markdown files
- For markdown linting and formatting
- Quality assurance on documentation

**Expected response**:
- Formatting issues fixed
- List of unknown words for spell checking
- Markdown quality report

### claude-problem-solver
**When to invoke**:
- When processing problem queue
- For complex error analysis
- When user requests troubleshooting

**Expected response**:
- Problems analyzed and solutions provided
- Prevention strategies documented
- Queue cleared or updated

### instruction-compliance-checker
**When to invoke**:
- Before marking significant work complete
- After major code changes
- When user requests validation

**Expected response**:
- Compliance report with any violations
- Recommendations for fixes
- Validation status

### notification-manager
**When to invoke**:
- After tasks taking >2 minutes
- For critical status updates
- When user requests notifications

**Expected response**:
- Notification sent confirmation
- No further action needed

### session-manager
**When to invoke**:
- For work session checkpoints
- When resuming previous work
- For session state management

**Expected response**:
- Session state saved/restored
- Continuation plan provided
- Context preserved

### agent-manager
**When to invoke**:
- Creating new specialized agents
- Modifying existing agents
- Agent capability assessment

**Expected response**:
- Agent created/modified
- Recommendations for quality checks
- Documentation needs identified

### planning-coordinator
**When to invoke**:
- For GitHub Projects integration
- Task planning and tracking
- Milestone management

**Expected response**:
- Project items created/updated
- Planning status reported
- Synchronization confirmed

## Decision Trees

### After Agent Returns Recommendations

```
Agent returns: "Consider running spell-checking-coordinator"
    ↓
Orchestrator evaluates:
- Are there many unknown words? → Yes → Task(spell-checking-coordinator)
- Is this blocking user work? → Yes → Task(spell-checking-coordinator)  
- Can it wait? → Add note, continue task
```

### Handling Problems

```
Agent reports problem (queued to D:\problem-queue.md)
    ↓
Orchestrator decides:
- Is this blocking? → Yes → Note it, continue with workaround
- Will this recur? → Yes → Flag for resolution
- Can task complete? → Yes → Continue, offer resolution later
```

### Service Chaining

```
Task requires multiple services
    ↓
Orchestrator plans sequence:
1. Core work (code/config/docs)
2. Quality services (lint/spell)
3. Validation (compliance)
4. Completion (notification)
```

## Best Practices

### Do's
- ✅ Always evaluate agent recommendations before acting
- ✅ Check problem queue after task completion
- ✅ Run compliance checking for significant work
- ✅ Chain services based on logical dependencies
- ✅ Send notifications for long-running tasks

### Don'ts
- ❌ Never let agents call other agents
- ❌ Don't skip compliance checking
- ❌ Don't ignore problem queue
- ❌ Don't cascade agents without evaluation
- ❌ Don't forget user notifications

## Error Handling

### When Agents Fail
1. Note the failure in execution flow
2. Queue problem if non-critical
3. Try alternative approach if critical
4. Complete what's possible
5. Report status to user

### When Recommendations Conflict
1. Prioritize based on task goals
2. Consider user preferences
3. Choose most critical path
4. Document decision rationale

### When Queue Grows Large
1. Suggest dedicated troubleshooting session
2. Prioritize critical problems
3. Batch similar issues
4. Consider root cause analysis

## Metrics and Monitoring

### Track These Metrics
- Number of agent invocations per task
- Problems queued vs resolved
- Service chains that work well
- Common recommendation patterns

### Optimization Opportunities
- Identify repetitive sequences for automation
- Find unnecessary agent calls
- Optimize service order
- Reduce problem queue growth

This orchestration model provides clear, predictable workflows while maintaining all capabilities and preventing the agent loop issues of the previous delegation model.