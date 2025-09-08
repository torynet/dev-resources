# CCPM Workflow Story: Building GitHub Issue Dependency Tracker with Claude Code

## The Setup
Alex is building a GitHub Issue Dependency Tracker using Claude Code's CCPM (Critical Chain Project Management) system. Having read about CCPM theory, Alex wants to see how it actually works with real Claude Code commands and project management tools.

## Phase 1: Project Initialization & Vision

Alex starts with a rough idea: "I need a tool that can track dependencies between GitHub issues and visualize them."

### Initial Brainstorming Session
```
claude> I want to build a GitHub issue dependency tracker. Can you help me think through this?
```
After discussion, Alex has a clearer vision and decides to formalize it using CCPM.

### Creating the First PRD
```
claude> /pm:prd-new issue-dependency-core
```
This creates `.claude/epics/issue-dependency-core/prd.md` with the core functionality:
- Parse GitHub issues for dependency syntax (`depends on #123`, `blocks #456`)
- Build dependency graph
- Detect circular dependencies
- Basic CLI interface

### Parsing and Validation
```
claude> /pm:prd-parse issue-dependency-core
```
Claude analyzes the PRD and creates:
- **Tasks**: 15 technical tasks identified
- **Estimates**: Realistic effort estimates without padding
- **Dependencies**: Task sequencing based on technical requirements
- **Critical Path**: Core parsing → Graph building → Cycle detection → CLI interface

## Phase 2: Epic Management & Synchronization

### Syncing with GitHub Projects
```
claude> /pm:epic-sync issue-dependency-core
```
Results:
- GitHub Project board created: "Issue Dependency Tracker"
- Draft issues created for each major milestone
- Project items synchronized with priority and status fields
- Buffer time allocated: 20% project buffer at the end

### Adding UI/Visualization Epic
Alex realizes they need a web interface:
```
claude> /pm:prd-new dependency-visualizer
```
New PRD covers:
- React-based dependency graph visualization
- Interactive node manipulation
- Export to various formats (PNG, SVG, DOT)
- Integration with core dependency engine

```
claude> /pm:prd-parse dependency-visualizer
claude> /pm:epic-sync dependency-visualizer
```

## Phase 3: Resource Constraint Identification

### The Reality Check
```
claude> /pm:status
```
Claude identifies the critical constraint:
- **Drum Resource**: Alex (solo developer) can only focus on one complex task at a time
- **Resource Conflicts**: Frontend and backend work both require Alex's full attention
- **Skill Bottlenecks**: Graph algorithms (core parsing) requires deep focus

### Critical Chain Emerges
After resource leveling:
1. **Core Parsing Logic** (Critical Chain) - 3 days
2. **Graph Building & Algorithms** (Critical Chain) - 2 days  
3. **Cycle Detection** (Critical Chain) - 1 day
4. **CLI Interface** (Feeding Chain) - 1 day parallel with testing
5. **Web Interface** (Critical Chain) - 2 days
6. **Integration & Testing** (Critical Chain) - 1 day

**Total Critical Chain**: 9 days + 2-day project buffer = 11 days

## Phase 4: Daily Execution & Buffer Management

### Day 1-3: Core Parsing Development
```
claude> /pm:issue-start 123
```
**Day 2 Challenge**: GitHub API rate limiting issues discovered
- **Buffer Impact**: 0.5 days consumed from project buffer
- **Status**: Green zone (25% buffer consumption)
- **Action**: Continue with planned work, document rate limiting solutions

### Day 4-5: Graph Building
```
claude> /pm:status
```
The status command delegates to a Task agent that analyzes project health (you may not see direct output, but the system internally tracks buffer consumption and progress).

**Day 5 Discovery**: Complex circular dependency detection needed
- **Buffer Impact**: Additional 0.3 days consumed  
- **Status**: Still green zone (40% buffer consumption)
- **Action**: Refactor approach, implement simpler algorithm first

### Day 6-7: Yellow Zone Management
```
claude> /pm:epic-status dependency-visualizer
```
**Alert Triggered**: Buffer consumption at 60% (yellow zone)
- **Automated Actions**:
  - Stakeholder notification sent
  - Daily buffer reviews activated
  - Scope protection protocols engaged
  
**Day 7 Decision**: Web interface complexity reduced
- **Scope Adjustment**: Basic visualization only, advanced features moved to v2
- **Buffer Protection**: 0.4 days saved through scope management

### Day 8-9: Web Interface Sprint  
```
claude> /pm:issue-start 124
```
**Relay Race Mentality**: Core engine completed and immediately handed off to web interface development
- No waiting for "perfect" core - good enough for integration
- Web development starts immediately with working core API
- Parallel testing begins on completed components

## Phase 5: Integration & Delivery

### Day 9-10: Final Integration
```
claude> /pm:epic-status issue-dependency-core
```
**Buffer Status**: 
```
🟡 Project Buffer: 0.7/2.0 days remaining (35% available) 
📈 Buffer Consumption Trend: Stabilizing
🎯 Delivery Confidence: High (85%)
```

**Integration Issues Found**:
- API response format mismatch between core and web interface
- **Buffer Impact**: 0.2 days for fixes
- **Status**: Still within acceptable buffer usage

### Final Day: Delivery
```
claude> /pm:epic-close issue-dependency-core
claude> /pm:epic-close dependency-visualizer  
```

**Project Completion Summary**:
- **Delivered**: Day 10.2 (vs 11-day target with buffer)
- **Buffer Usage**: 1.3/2.0 days consumed (65% utilization)
- **Scope**: Core functionality delivered, advanced features properly deferred
- **Quality**: All critical path items tested and working

## Phase 6: Multi-Project Orchestration

### Adding CLI Enhancement Epic
```
claude> /pm:prd-new cli-foundation
claude> /pm:prd-parse cli-foundation
claude> /pm:epic-decompose cli-foundation
claude> /pm:epic-sync cli-foundation
```

**Resource Scheduling Output**:
```
Week 1: issue-dependency-core (Critical Chain work)
Week 2: dependency-visualizer (Morning: Critical Chain, Afternoon: cli-foundation feeding tasks)  
Week 3: cli-foundation (Critical Chain focus)
```

**Drum Scheduling**: Alex's focused morning hours reserved for critical chain work only, routine tasks scheduled for lower-energy afternoon periods.

## The CCPM Mindset in Action

### Traditional Approach vs CCPM
**Before CCPM**: 
- Each component padded: Core (5 days), UI (4 days), Integration (2 days) = 11 days
- Sequential handoffs with delays between components
- Individual component "perfection" before handoff
- Crisis management when delays occurred

**With CCPM**:
- Honest estimates: 7 days + 2-day project buffer = 9 days delivered  
- Immediate handoffs using "good enough" principle
- Proactive buffer management prevented crisis mode
- Clear visibility into project health throughout

### Key Behavioral Changes
1. **Relay Race Execution**: Each component finished and immediately passed to next stage
2. **Buffer-Driven Decisions**: Scope adjustments made based on buffer consumption, not arbitrary deadlines
3. **Focus Protection**: Critical chain work protected from interruptions and scope creep
4. **Honest Communication**: Buffer status provided clear, objective project health metrics

This story shows how CCPM transforms software project management from deadline-driven crisis management into a systematic, buffer-protected delivery system that actually delivers faster and with less stress.