# Problem Queue

This file tracks problems encountered by agents during task execution. Problems are queued here for later resolution by the claude-problem-solver agent.

## Queue Format

Each problem entry should include:
- Timestamp of when the problem occurred
- Agent that encountered the problem
- Description of the problem with full context
- Any error messages or relevant details

## Pending Problems

- [ ] [2025-08-20 14:35] notification-manager: Test problem queuing - encountered hypothetical notification delivery failure during architecture validation test
- [ ] [2025-08-20 14:35] notification-manager: Test problem context - would normally need documentation-specialist for markdown quality but cannot delegate from Tier 3

## Resolved Problems (Archive)

### ✅ Three-Tier Architecture Migration Complete (2025-08-20)
**Resolved**: Successfully migrated from agent-to-agent delegation to three-tier architecture
**Changes Made**:
- Converted 3 Tier 3 service agents: spell-checking-coordinator, documentation-specialist, notification-manager
- Updated 3 Tier 2 domain agents: object-model-documenter, decision-documenter, agent-manager  
- Tested delegation patterns - confirmed no loops possible
- All agents now comply with tier restrictions
**Benefits**: Eliminated crash loops while maintaining service reusability

### ✅ Documentation Service Optimization Complete (2025-08-20)
**Resolved**: Successfully merged documentation-specialist and spell-checking-coordinator into single comprehensive service
**Changes Made**:
- Combined formatting and spell checking into single Tier 3 service
- Updated all Tier 2 agents to use merged service
- Eliminated need for two-step document processing
- Reduced orchestration complexity
**Benefits**: Simpler architecture with single call for complete document quality

### ✅ Self-Bootstrapping Session Management Complete (2025-08-20)
**Resolved**: Successfully implemented self-bootstrapping session management with project-specific separation
**Changes Made**:
- Replaced user-level session manager with self-bootstrapping generic version
- Created Storacle project-specific session manager with GitHub Projects integration
- Extracted all Storacle-specific details from user-level to project-level
- Implemented auto-detection and project agent creation capabilities
**Benefits**: Universal session management with project-specific optimization and automatic setup

---

### Usage Instructions

**For Agents**:
- When encountering non-blocking problems, append to "Pending Problems" section
- Format: `- [ ] [timestamp] agent-name: Problem description`
- Include enough context for troubleshooting

**For Orchestrator**:
- Check this file after task completion
- Offer to run claude-problem-solver if pending problems exist
- Archive resolved problems with resolution notes

**For claude-problem-solver**:
- Process pending problems when invoked
- Move resolved items to archive with resolution summary
- Update prevention strategies in claudeProblems.md as needed