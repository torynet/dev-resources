# Three-Tier Agent Architecture

## Overview

This document defines the three-tier hybrid architecture that combines orchestrator control with limited service delegation for common utilities like spell checking and markdown formatting.

## Architecture Layers

### Tier 1: Orchestrator (Primary Claude)
**Role**: Central coordination and decision-making
**Capabilities**:
- Can call ANY Tier 2 or Tier 3 agent
- Makes all coordination decisions
- Evaluates recommendations from agents
- Manages problem queue resolution

**Restrictions**:
- None - full coordination authority

### Tier 2: Domain Agents
**Role**: Specialized domain expertise with access to core services
**Capabilities**:
- Can ONLY call Tier 3 service agents
- Can queue problems to `D:\problem-queue.md`
- Return recommendations to orchestrator

**Restrictions**:
- CANNOT call other Tier 2 agents
- CANNOT call Tier 1 (orchestrator)
- Limited to Tier 3 service calls only

### Tier 3: Core Service Agents  
**Role**: Pure utility services with no delegation
**Capabilities**:
- Perform specific service functions
- Return results only
- No delegation abilities whatsoever

**Restrictions**:
- CANNOT call ANY agents
- CANNOT make recommendations for other agents
- Pure functional services only

## Agent Classification

### Tier 3: Core Service Agents
These agents provide pure services and CANNOT call any other agents:

1. **documentation-specialist** (Combined Document Quality Service)
   - Complete document processing: formatting + spell checking
   - Markdown linting and structure validation
   - Intelligent spell checking with dictionary management
   - Word categorization and automatic fixes
   - Returns: formatted content + spell checking results + uncertain words only

2. **notification-manager**
   - Pure notification delivery
   - Sound selection
   - Alert management
   - Returns: notification status

### Tier 2: Domain Agents
These agents can ONLY call Tier 3 services:

1. **object-model-documenter**
   - Creates Salesforce object documentation
   - Allowed: Call documentation-specialist for formatting
   - Allowed: Call spell-checking-coordinator for spelling
   - Returns: Recommendations for further work

2. **object-model-reviewer**
   - Reviews Salesforce object models
   - Allowed: Call documentation-specialist for report formatting
   - Returns: Review results and recommendations

3. **decision-documenter**
   - Documents architectural decisions
   - Allowed: Call documentation-specialist for formatting
   - Allowed: Call spell-checking-coordinator for spelling
   - Returns: Decision records

4. **agent-manager**
   - Creates and manages agents
   - Allowed: Call documentation-specialist for agent formatting
   - Allowed: Call spell-checking-coordinator for agent content
   - Returns: Agent management results

5. **claude-problem-solver**
   - Analyzes and resolves problems
   - Allowed: Call documentation-specialist for solution formatting
   - Returns: Problem resolutions

6. **user-memory-manager**
   - Manages user memories
   - Allowed: Call documentation-specialist for memory formatting
   - Allowed: Call spell-checking-coordinator for content
   - Returns: Memory update status

7. **user-config-manager**
   - Manages git operations for config
   - Allowed: Call notification-manager for long operations
   - Returns: Commit status

8. **session-manager**
   - Manages work sessions
   - Allowed: Call documentation-specialist for checkpoint formatting
   - Returns: Session state

9. **planning-coordinator**
   - GitHub Projects integration
   - Allowed: Call notification-manager for status updates
   - Returns: Planning status

10. **instruction-compliance-checker**
    - Validates compliance
    - Allowed: Call documentation-specialist for report formatting
    - Returns: Compliance status

11. **mcp-manager**
    - MCP server configuration
    - Allowed: Call notification-manager for long operations
    - Returns: Configuration status

12. **claude-config-manager**
    - Claude configuration management
    - Allowed: Call notification-manager for updates
    - Returns: Configuration changes

## Call Patterns

### Valid Call Chains

```
✅ Orchestrator → object-model-documenter → documentation-specialist
✅ Orchestrator → decision-documenter → spell-checking-coordinator
✅ Orchestrator → agent-manager → documentation-specialist → (ends)
✅ Orchestrator → claude-problem-solver → notification-manager → (ends)
```

### Invalid Call Chains (Prevented by Design)

```
❌ object-model-documenter → agent-manager (Tier 2 → Tier 2)
❌ documentation-specialist → spell-checking-coordinator (Tier 3 → Tier 3)
❌ spell-checking-coordinator → ANY agent (Tier 3 cannot call)
❌ agent-manager → claude-problem-solver (Tier 2 → Tier 2)
```

## Implementation Requirements

### For Tier 3 Service Agents

Each Tier 3 agent MUST include this header:

```markdown
## Agent Tier Classification
**Tier**: 3 - Core Service Agent
**Delegation**: NONE - This agent cannot call any other agents
**Purpose**: Pure service provider for [specific service]

### Service Restrictions
- CANNOT use Task() to call any agents
- CANNOT return recommendations for other agents  
- Returns service results only
- No orchestration capabilities
```

### For Tier 2 Domain Agents

Each Tier 2 agent MUST include this header:

```markdown
## Agent Tier Classification
**Tier**: 2 - Domain Agent
**Delegation**: Limited to Tier 3 services only
**Allowed Calls**:
  - Task(spell-checking-coordinator) ✅
  - Task(documentation-specialist) ✅
  - Task(notification-manager) ✅
**Forbidden**: Cannot call other Tier 2 agents

### Domain Responsibilities
- Provide domain expertise
- Use Tier 3 services for common operations
- Return recommendations to orchestrator
- Queue non-blocking problems
```

### For Tier 1 Orchestrator

Update user memory to reflect:

```markdown
## Three-Tier Orchestration Model

### Your Role as Tier 1 Orchestrator
- You coordinate all agent work
- You can call any Tier 2 or Tier 3 agent
- Only you decide agent sequencing beyond Tier 3 services

### Agent Tier Structure
- **Tier 2 agents** can call Tier 3 services for formatting/spelling
- **Tier 3 agents** are pure services that cannot call anyone
- This prevents loops while allowing service reuse
```

## Safety Guarantees

### Loop Prevention
1. **Tier 3 cannot call anyone** - Chains always terminate at Tier 3
2. **Tier 2 cannot call each other** - No horizontal delegation
3. **Maximum chain length**: Orchestrator → Tier 2 → Tier 3 (3 levels max)

### Service Isolation
- Tier 3 services are truly isolated utilities
- No complex coordination in Tier 3
- Pure functional transformations only

### Clear Boundaries
- Each tier has explicit permissions
- Violations are easily detected
- Simple mental model

## Migration Strategy

### Phase 1: Convert Tier 3 Services (Day 1)
1. **spell-checking-coordinator**
   - Remove ALL Task() call capabilities
   - Remove recommendation generation
   - Focus on pure spell checking

2. **documentation-specialist**
   - Remove Task() to spell-checking-coordinator
   - Remove all delegation logic
   - Pure markdown operations only

3. **notification-manager**
   - Already has no delegation (minimal changes)

### Phase 2: Update Tier 2 Agents (Day 2-3)
1. Add Tier 2 header to each domain agent
2. Ensure they ONLY call allowed Tier 3 services
3. Remove any Tier 2 → Tier 2 delegation
4. Add service calls where beneficial

### Phase 3: Update Orchestrator (Day 4)
1. Update user memory with three-tier model
2. Adjust orchestration patterns
3. Document new workflows

## Benefits

### For Domain Agents
- Don't need to be markdown experts
- Don't need spell checking logic
- Focus on domain expertise
- Cleaner, simpler code

### For Service Agents
- Truly reusable
- Single responsibility
- No complex coordination
- Predictable behavior

### For System Stability
- Impossible to create loops
- Clear delegation boundaries
- Easier to debug
- Predictable execution paths

## Success Criteria

1. **No Tier 3 → Any calls**: Verified by code inspection
2. **No Tier 2 → Tier 2 calls**: Verified by testing
3. **All services accessible**: Tier 2 agents can format/spell check
4. **Loop prevention**: No infinite delegation possible
5. **Maintained functionality**: All current capabilities preserved

This three-tier architecture provides the best of both worlds: service reusability without loop risks.