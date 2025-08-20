# Orchestrator Pattern Migration Plan

## Executive Summary

This document outlines the complete migration from our current agent-to-agent delegation model to a three-tier architecture where Primary Claude orchestrates, domain agents can call service agents, and service agents are pure utilities that cannot call anyone.

## Architecture Overview

### Current Model (To Be Replaced)
```
Primary Claude
    ↓ Task()
Agent A 
    ↓ Task()
Agent B
    ↓ Task()
Agent C (potential loops/crashes)
```

### New Three-Tier Model
```
Tier 1: Primary Claude (Orchestrator)
    ↓ Task() → Tier 2: Domain Agent (e.g., object-model-documenter)
                    ↓ Task() → Tier 3: Service Agent (spell/format/notify)
                    ↓ Returns pure service results
              ← Returns results + recommendations to Orchestrator
    ↓ Orchestrator decides next steps
```

### Tier Definitions
- **Tier 1 (Orchestrator)**: Primary Claude - Full coordination authority, can call any agent
- **Tier 2 (Domain Agents)**: Specialized expertise - Can ONLY call Tier 3 service agents
- **Tier 3 (Service Agents)**: Pure utilities - Cannot call any agents, terminal nodes

## Core Design Principles

### 1. Hierarchical Decision Making
- **Primary Claude** orchestrates all high-level coordination
- **Tier 2 agents** can call Tier 3 services for formatting/spelling/notifications
- **Tier 3 agents** cannot call anyone - preventing loops
- Coordination happens at orchestrator level, services at domain level

### 2. Agent Response Format
Each agent returns a structured response:
```markdown
## Work Completed
[Details of what was done]

## Recommendations for Orchestrator
- [ ] Consider running another domain agent for related work
- [ ] Note: I've already handled spell/format/notify via Tier 3 services
- [ ] Consider running claude-problem-solver for errors encountered

## Problems Encountered
[Any issues that need troubleshooting - automatically queued]
```

### 3. Problem Queue System
- Location: `D:\problem-queue.md`
- Format:
```markdown
# Problem Queue

## Pending Problems
- [ ] [timestamp] agent-name: Error description and context
- [ ] [timestamp] agent-name: Another issue needing resolution

## Resolved Problems (Archive)
- [x] [timestamp] Previously resolved issue
```

## Agent Migration Strategy

### Phase 1: Tier 3 Service Agents
These become pure service utilities that cannot call any agents:

#### spell-checking-coordinator (Tier 3)
**Changes Required**:
- Remove ALL Task() calls - cannot call any agents
- Pure spell checking service only
- Return categorized words and dictionary updates
- No recommendations for other agents

#### documentation-specialist (Tier 3)
**Changes Required**:
- Remove ALL Task() calls - cannot call any agents
- Pure markdown formatting and linting service
- Return formatted content and linting results
- No delegation or recommendations

#### notification-manager (Tier 3)
**Changes Required**:
- Already a pure service (minimal changes)
- Ensure no Task() calls exist
- Return notification status only

### Phase 2: Tier 2 Domain Agents
These agents can call ONLY Tier 3 services:

#### agent-manager (Tier 2)
**Changes Required**:
- Keep Task() calls to Tier 3 services (spell/format/notify)
- Remove any Task() calls to other Tier 2 agents
- Can call documentation-specialist for formatting
- Can call spell-checking-coordinator for spelling

#### claude-problem-solver (Tier 2)
**Changes Required**:
- Can call documentation-specialist for formatting solutions
- Can call notification-manager for long operations
- Remove calls to other Tier 2 agents
- Process problem queue when invoked

#### object-model-documenter (Tier 2)
**Changes Required**:
- Can call documentation-specialist for formatting
- Can call spell-checking-coordinator for spelling
- Remove any Tier 2 agent calls
- Focus on Salesforce documentation

#### decision-documenter (Tier 2)
**Changes Required**:
- Can call documentation-specialist for formatting
- Can call spell-checking-coordinator for spelling
- Remove any Tier 2 agent calls
- Focus on decision records

#### Other Tier 2 Agents
**Common Changes for All**:
- Can call ONLY Tier 3 services (spell/format/notify)
- Remove ALL calls to other Tier 2 agents
- Queue problems to `D:\problem-queue.md`
- Return recommendations to orchestrator

**Agents to Update**:
- session-manager
- planning-coordinator
- user-memory-manager
- user-config-manager
- mcp-manager
- claude-config-manager
- instruction-compliance-checker
- object-model-reviewer

### Phase 4: Specialized Agents
Domain-specific agents with focused responsibilities:

#### object-model-documenter
#### object-model-reviewer  
#### decision-documenter
#### user-memory-manager
#### instruction-compliance-checker

**Changes for All**:
- Remove any Task() calls
- Return recommendations only
- Queue domain-specific problems
- Maintain core functionality

## New Orchestrator Workflows

### Standard Task Workflow
```python
1. User requests task
2. Orchestrator analyzes requirements
3. Orchestrator calls relevant agent(s) sequentially
4. Each agent returns results + recommendations
5. Orchestrator evaluates recommendations
6. Orchestrator decides next steps
7. Repeat 3-6 until task complete
8. Offer to process problem queue
```

### Automatic Service Integration
The orchestrator will automatically:
- Run spell-checking-coordinator when agents report unknown words
- Run documentation-specialist for markdown quality
- Run instruction-compliance-checker before task completion
- Run notification-manager for long-running tasks
- Run decision-documenter for architectural decisions

### Problem Queue Processing
```markdown
At task completion, orchestrator checks D:\problem-queue.md:
- If problems exist: "Found N problems in queue. Run troubleshooter now?"
- If user accepts: Task(claude-problem-solver) to process queue
- If user declines: Problems remain for later session
```

## Implementation Plan

### Step 1: Update User Memory (Immediate)
Update `C:\Users\telar\.claude\CLAUDE.md` to establish orchestrator pattern

### Step 2: Create Agent Update Template
Create standardized update pattern for all agents:
```markdown
## Agent Communication Protocol

### Orchestrator Pattern Compliance
This agent operates under the orchestrator pattern where:
- Only Primary Claude (orchestrator) can invoke this agent
- This agent CANNOT call other agents via Task()
- All coordination needs are returned as recommendations
- Problems are queued to D:\problem-queue.md

### Response Format
Always return:
1. Work completed (what was done)
2. Recommendations for orchestrator (what agents might help)
3. Problems encountered (queued automatically)
```

### Step 3: Update Agents in Phases
1. **Day 1**: Core service agents (spell, docs, problems, notifications)
2. **Day 2**: Coordination agents (agent-manager, session-manager, planning)
3. **Day 3**: Configuration agents (mcp, claude-config, user-config)
4. **Day 4**: Specialized agents (remaining agents)

### Step 4: Remove Legacy Systems
- Remove delegation depth tracking
- Remove circuit breaker logic
- Remove queue-based delegation system
- Simplify agent activity logging

### Step 5: Testing and Validation
- Test each agent in isolation
- Verify no Task() calls between agents
- Validate problem queue operations
- Confirm orchestrator coordination

## Benefits of Migration

### Immediate Benefits
- **Eliminates crash loops** - Impossible for agents to create loops
- **Simplified debugging** - Linear execution trace
- **Clear accountability** - One decision point
- **Better visibility** - Orchestrator sees everything

### Long-term Benefits
- **Easier maintenance** - Simpler agent code
- **Flexible workflows** - Orchestrator can adapt patterns
- **Better user control** - User can guide orchestrator decisions
- **Scalable architecture** - Easy to add new agents

## Success Criteria

### Technical Success
- Zero agent-to-agent Task() calls
- All agents return structured responses
- Problem queue operational
- Orchestrator handles all coordination

### Functional Success  
- All current capabilities maintained:
  - Spell checking automation
  - Markdown linting
  - Decision documentation
  - Compliance checking
  - Problem solving
  - Session management
  - Notifications

### User Experience Success
- Clear task progression
- Transparent decision making
- Optional problem resolution
- No unexpected cascading actions

## Risk Mitigation

### Migration Risks
- **Broken Workflows**: Test each agent after update
- **Lost Functionality**: Maintain feature checklist
- **User Confusion**: Clear documentation of changes

### Mitigation Strategies
- Update agents incrementally
- Test in isolated scenarios
- Maintain rollback capability
- Document all changes

## Next Steps

1. **Approve this plan**
2. **Update user memory immediately**
3. **Begin Phase 1 agent updates**
4. **Create problem queue system**
5. **Test orchestrator workflows**
6. **Complete migration over 4 days**

This migration will fundamentally improve system reliability while maintaining all current capabilities in a cleaner, more maintainable architecture.