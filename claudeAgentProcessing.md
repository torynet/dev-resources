# Claude Agent Processing Strategy

## Problem Statement

Claude Code was experiencing recurring system freezes due to infinite delegation loops between agents. The root cause was "institutional knowledge" agents continuously triggering each other to improve the system, creating circular dependencies that exhausted system resources.

## Core Issue Analysis

### Freezing Pattern
1. **First Instance**: Spell checking operations with circular cspell configuration imports
2. **Second Instance**: Agent-manager trying to update agents, triggering documentation improvements, which triggered more agent improvements

### Root Cause: Circular Agent Dependencies
- Agent-Manager → Documentation-Specialist → Agent-Manager (infinite loop)
- Spell-Checking-Coordinator → Agent-Manager → Spell-Checking-Coordinator (infinite loop)
- Multiple agents all trying to "improve the system" simultaneously

## Solution Architecture

### Hybrid Delegation Strategy

**Combines depth-limited real-time delegation with queue-based improvement processing**

#### Three-Tier Decision System

1. **Depth Check**: Prevent infinite loops with maximum delegation depth
2. **Work Type Check**: Distinguish urgent vs improvement work  
3. **Safety Fallback**: Queue everything at maximum depth

#### Configuration

**Maximum Delegation Depth**: 3 levels
- **Storage Location**: `C:\Users\telar\.claude\CLAUDE.md` under "Delegation Configuration"
- **Rationale**: Allows reasonable delegation chains while preventing infinite loops
- **Adjustable**: Can be modified in CLAUDE.md based on system performance and user needs

### Agent Processing Categories

#### Real-Time Delegation (With Depth Limits)
**Criteria**: User-requested work OR blocking issues AND delegation_depth < MAX_DEPTH

**Always Real-Time**:
- `notification-manager` - Notifications must be immediate
- `claude-problem-solver` - Error analysis is blocking (when depth allows)

**Conditional Real-Time** (user-requested or blocking, within depth limit):
- `claude-config-manager` - Configuration changes
- `mcp-manager` - MCP operations
- `documentation-specialist` - User-requested documentation work
- `spell-checking-coordinator` - Blocking spell errors
- `user-memory-manager` - User-requested memory operations
- `planning-coordinator` - User-requested planning
- `session-manager` - User-requested session operations

#### Queue-Based Delegation (Improvement Work)
**Criteria**: System optimization, institutional knowledge building, OR delegation_depth >= MAX_DEPTH

- `spell-checking-coordinator` - Dictionary improvements, terminology optimization
- `agent-manager` - Agent ecosystem improvements and optimization
- `user-memory-manager` - Knowledge building and pattern storage
- `documentation-specialist` - Documentation improvements (unless user-requested)
- `object-model-documenter` - Object model optimization work
- `planning-coordinator` - Planning optimization and workflow improvements

### Implementation Strategy: Hybrid Approach

**Primary Decision Logic**: Depth-limited real-time with improvement queuing

#### Hybrid Delegation Decision Logic

```
Task Delegation Request Received:

1. Check delegation_depth parameter:
   ├─ delegation_depth >= MAX_DELEGATION_DEPTH (3) → Queue (safety fallback)
   └─ delegation_depth < MAX_DELEGATION_DEPTH → Continue to work type check

2. Check work type:
   ├─ User explicitly requested this work → Real-time (increment depth)
   ├─ Blocking error preventing user's request → Real-time (increment depth)  
   ├─ Critical system failure → Real-time (increment depth)
   └─ System improvement/optimization → Queue

3. Safety checks:
   ├─ Notifications → Always real-time (any depth)
   └─ Error analysis → Real-time if depth allows, queue if at max depth
```

#### Real-Time Delegation Criteria
1. **User explicitly requests** the specific agent work AND delegation_depth < MAX_DEPTH
2. **Blocking error** that prevents completion of user's current request AND delegation_depth < MAX_DEPTH
3. **Critical system failure** requiring immediate intervention AND delegation_depth < MAX_DEPTH
4. **Notifications** - always immediate regardless of depth
5. **Error analysis** - immediate if depth allows

#### Queue-Based Processing
- System improvement and optimization work (always queued)
- Any work at maximum delegation depth (safety fallback)
- User controls when queues are processed
- No automatic cross-agent triggering during queue processing

### Queue Management Architecture

#### Queue Ownership Model
- **Queue Ownership**: Each agent exclusively owns and manages its own queue file
- **Queue Location**: Co-located with agent definitions (user-level agents → user-level queues, project agents → project queues)
- **Write Access**: Only the owning agent modifies its queue file
- **Queue Addition**: Other agents delegate queue additions via `work_type="queue_addition"`

#### Queue Location Strategy
- **User-level agents**: `C:\Users\telar\.claude\queues\agent-name-queue.md`
- **Project-level agents**: `project/.claude/queues/agent-name-queue.md`
- **Co-location principle**: Queues stored alongside their corresponding agent definitions

#### Exclusive Queue Addition Operation

**CRITICAL: Queue addition is a non-delegating, loop-breaking operation**

**When `work_type="queue_addition"`:**
- ✅ **Only add to own queue** - no further delegation allowed
- ✅ **No other work performed** - don't process the item
- ✅ **No depth checking needed** - this operation is always safe at any depth
- ✅ **Immediate completion** - add item and return immediately
- ✅ **Universal safety valve** - terminates any delegation chain

**Queue Addition Syntax:**
```
Task(agent-name, work_type="queue_addition", item="Task description", delegation_depth=any)
```

### Queue File Format

```markdown
# agent-name-queue.md

## Pending Tasks
- [ ] Task description with context
- [ ] Another task with priority info

## Completed Tasks (Archive)
- [x] Previously completed task
```

### Primary Claude Workflow

1. **Start user request** with delegation_depth = 0
2. **During processing**:
   - For urgent work: delegate real-time with incremented depth
   - For improvement opportunities: add to appropriate queues
   - Track delegation depth for all Task calls
3. **Handle delegation responses**: Process agent results and continue work
4. **Complete primary user request**
5. **After completion, offer**: "Task complete. Agent queues have N pending items. Process now?"

### Delegation Depth Management

**Primary Claude Responsibilities**:
- Initialize all user-requested work with `delegation_depth=0`
- Increment depth for each real-time delegation: `delegation_depth=current_depth + 1`
- Pass depth parameter in all Task calls: `Task(subagent_type="agent-name", delegation_depth=2)`
- Enforce maximum depth limit (3) as safety fallback

## Decision Logic for Primary Claude

### Hybrid Delegation Decision Tree

```
Task delegation request with delegation_depth parameter:

1. Check for queue addition:
   ├─ work_type="queue_addition" → Add to own queue and return immediately (universal safety valve)
   └─ Otherwise → Continue to depth check

2. Check depth limit:
   ├─ delegation_depth >= 3 → Add to queue via queue_addition (safety fallback)
   └─ delegation_depth < 3 → Continue to work type check

3. Check work type:
   ├─ User explicitly requested this work → Real-time (depth + 1)
   ├─ Blocking error preventing user's request → Real-time (depth + 1)
   ├─ Critical system failure → Real-time (depth + 1)
   ├─ Notification needed → Real-time (any depth)
   └─ System improvement/optimization → Queue via queue_addition
```

### Examples

**Queue Addition** (universal safety valve):
- Agent needs to add improvement work → `Task(documentation-specialist, work_type="queue_addition", item="Format agent files")`
- At max depth fallback → `Task(spell-checking-coordinator, work_type="queue_addition", item="Add dictionary terms")`
- Cross-agent improvement → `Task(agent-manager, work_type="queue_addition", item="Review delegation patterns")`

**Real-Time** (depth permitting):
- User: "Fix my spell checking" → `Task(spell-checking-coordinator, delegation_depth=1)`
- Error: "Cannot complete task due to MCP failure" → `Task(mcp-manager, delegation_depth=2)`  
- User: "Update my agents" → `Task(agent-manager, delegation_depth=1)`
- Completion notification → `Task(notification-manager, delegation_depth=any)` (always immediate)

**Queued** (improvement work):
- During documentation work: "I notice some agents could be improved" → `Task(agent-manager, work_type="queue_addition", item="Review agent ecosystem")`
- While working: "Found some dictionary terms to add" → `Task(spell-checking-coordinator, work_type="queue_addition", item="Add technical terms")`
- After code changes: "Documentation could be enhanced" → `Task(documentation-specialist, work_type="queue_addition", item="Update documentation")`
- At max depth: Any delegation → `Task(target-agent, work_type="queue_addition", item="Deferred work")`

## Hybrid Agent Behavior

Some agents operate in both modes:

### claude-problem-solver
- **Real-time**: Error analysis when problems block current work
- **Queue**: System improvement recommendations and pattern analysis

### documentation-specialist  
- **Real-time**: When user explicitly requests documentation work
- **Queue**: Documentation improvement suggestions during other work

### Configuration Agents (config-manager, mcp-manager)
- **Real-time**: When user explicitly requests changes
- **Queue**: Optimization suggestions discovered during other work

## Benefits of Queue-Based Approach

1. **Eliminates Infinite Loops**: No automatic agent-to-agent triggering
2. **User Control**: User decides when to process improvement work
3. **Transparency**: Clear visibility into pending work across all agents
4. **Batching Efficiency**: Process multiple similar tasks together
5. **System Stability**: Conservative approach prevents resource exhaustion

## Implementation Notes

### Immediate Changes
- Suspend all automatic delegation to institutional knowledge agents
- Only delegate real-time for explicit user requests or blocking errors
- Handle spell checking, documentation formatting, and agent improvements manually until queue system is built

### Queue System Development
- Create queue file format and storage mechanism
- Implement queue processing workflows
- Add user interface for queue management
- Test system stability with new approach

## Future Considerations

### Potential Improvements
1. **Smart work type detection** - Train Claude to better distinguish primary vs improvement work
2. **Priority queues** - High/medium/low priority items within queues
3. **Automatic queue processing** - Process low-priority queues during idle time
4. **Cross-agent coordination** - Coordinate related tasks across multiple agent queues

### Edge Cases to Monitor
1. What constitutes a "blocking" error vs an "improvement opportunity"?
2. How to handle chain reactions where real-time work discovers additional issues?
3. Queue overflow management if improvement tasks accumulate faster than processing
4. User preference for immediate vs deferred processing in different contexts

## Success Metrics

1. **Zero system freezes** during normal Claude Code operation
2. **Maintained functionality** for all agent capabilities
3. **User satisfaction** with balance of immediate response vs system stability
4. **Clear queue management** workflow that doesn't burden the user