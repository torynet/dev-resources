# Problem Queue

This file tracks problems encountered by agents during task execution. Problems are queued here for later resolution by the claude-problem-solver agent.

## Queue Format

Each problem entry should include:
- Timestamp of when the problem occurred
- Agent that encountered the problem
- Description of the problem with full context
- Any error messages or relevant details

## Pending Problems

*All problems have been resolved and moved to the archive section below*
  - `/agents` command shows no results despite 17 agents in C:\Users\telar\.claude\agents\
  - Task tool only discovers 'general-purpose', 'statusline-setup', 'output-style-setup'
  - All user-level agents (agent-manager, session-manager, etc.) not being discovered
  - This blocks the entire three-tier agent ecosystem functionality
  - Need immediate investigation into agent discovery/registration mechanism
  - Potential causes: Configuration corruption, system changes, Claude Code bug
  - Impact: Cannot use any specialized agents, ecosystem effectively broken
- [x] [2025-08-20 14:35] notification-manager: Test problem queuing - RESOLVED (removed three-tier restrictions)
- [x] [2025-08-20 14:35] notification-manager: Test problem context - RESOLVED (removed three-tier restrictions)

## Resolved Problems (Archive)

### ✅ Agent Discovery System Fixed and Three-Tier Architecture Removed (2025-08-25)
**Resolved**: Fixed complete Claude Code agent discovery failure and removed three-tier architecture
**Changes Made**:
- Eliminated three-tier agent architecture system entirely
- Removed all agent-to-agent calling patterns from 16 user-level and 2 project-level agents  
- Added mandatory agent isolation admonition: "⚠️ CRITICAL: This agent MUST NEVER call other agents. Agents do not call agents."
- Implemented standardized logging across all agents with format: `echo "$(date '+%Y-%m-%d %H:%M:%S') - [agent-name]: [task]" >> ${DEV}claude-agent.log`
- Updated user memory to reflect simplified delegation model
- Resolved agent discovery issues through architecture simplification
- Implemented context-aware spell checking with project dictionary inheritance
- Updated all documentation to reflect new architecture
**Benefits**: Eliminated complex tier system while maintaining specialization, improved agent discovery reliability, added comprehensive logging, simplified maintenance

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