# Hybrid Work Model: Strategic Orchestrator + CCPM Execution

## Overview

This document defines a hybrid approach that combines strategic human-controlled orchestration with automated project management execution. The model provides strategic decision-making rigor while enabling parallel execution efficiency.

## Core Philosophy

**Strategic decisions remain under human control for better outcomes.**  
**Execution tasks leverage automated parallel processing for efficiency.**

## Architecture Components

### Strategic Orchestrator (User + Claude)
- **Purpose**: High-level planning, architecture decisions, design choices
- **Control**: What gets built, how it's architected, quality standards
- **Tools**: Agent delegation, decision documentation, compliance checking
- **Scope**: Vision, requirements, architecture, trade-offs, quality gates

### CCPM Execution System
- **Purpose**: Implementation, testing, routine development tasks  
- **Control**: How it gets built, parallel coordination, progress tracking
- **Tools**: PRD workflows, parallel agents, GitHub integration, automated testing
- **Scope**: Implementation details, file organization, testing, status reporting

## Decision Boundaries

```
Strategic Decisions (Orchestrator):
├── What should we build?
├── How should it be architected?
├── What are the trade-offs?
├── Is this the right approach?
├── Quality acceptance criteria
└── Cross-system integration

Execution Decisions (CCPM):
├── How to implement the defined design?
├── Which files need changes?
├── Test execution and validation  
├── Git workflow and branching
├── Progress tracking and reporting
└── Parallel work coordination
```

## Three-Phase Workflow

### Phase 1: Strategic Planning (Orchestrator)
**Participants**: User + Claude Orchestrator + Specialized Agents

**Activities**:
- Requirements analysis and validation
- Architecture and design decisions
- Technology selection and trade-off analysis
- Breaking complex problems into manageable epics
- Defining acceptance criteria and quality gates

**Agent Patterns**:
```
User: "I need to add user authentication to Storacle"

Orchestrator:
├── Task(decision-documenter) → Architecture analysis with options
├── Task(object-model-documenter) → Salesforce object design  
├── Task(planning-coordinator) → GitHub project setup
└── Task(instruction-compliance-checker) → Standards validation

All agents work in isolation - no agent-to-agent calls
Output: PRD with clear requirements, architecture decisions, acceptance criteria
```

### Phase 2: Execution Management (CCPM)
**Participants**: CCPM System + Parallel Workers + Service Agents

**Activities**:
- Converting PRDs to executable epics
- Decomposing epics into parallel work streams
- Managing concurrent implementation across multiple agents
- Automated testing and validation
- Progress tracking and GitHub synchronization

**CCPM Patterns**:
```
/pm:prd-parse "storacle-auth"      # Convert PRD to epic
/pm:epic-decompose "storacle-auth" # Break into parallel tasks  
/pm:epic-sync "storacle-auth"      # Push to GitHub Projects
/pm:epic-start "storacle-auth"     # Launch parallel execution

parallel-worker spawns:
├── Stream A: Database schema changes
├── Stream B: API endpoint implementation
├── Stream C: Frontend authentication UI
└── Stream D: Test suite development
```

### Phase 3: Quality Review (Orchestrator)
**Participants**: User + Claude Orchestrator + Service Agents

**Activities**:
- Implementation quality assessment
- Test coverage validation  
- Standards compliance verification
- Integration testing and validation
- Acceptance criteria evaluation

**Quality Patterns**:
```
User: "Review the authentication implementation"

Orchestrator:
├── Task(code-analyzer) → Implementation quality review
├── Task(test-runner) → Test coverage validation
├── Task(instruction-compliance-checker) → Standards compliance
└── Decision: Approve, request changes, or iterate

All agents work independently and return results to orchestrator
```

## Handoff Protocol

### Strategic → Execution Handoff
**Trigger**: Completed architecture decisions and PRD
**Deliverables**:
- Detailed PRD with clear requirements
- Architecture decisions and design specifications
- Technology choices with rationale
- Acceptance criteria and quality gates
- Definition of done

### Execution → Review Handoff  
**Trigger**: Implementation completion reported by CCPM
**Deliverables**:
- Working implementation with test coverage
- Documentation of changes made
- Test results and validation reports
- GitHub sync confirmation
- Status summary with any blockers

## Agent Coordination Rules

### Orchestrator Controls
- **Requirements Definition**: What needs to be built and why
- **Architecture Decisions**: System design, integration patterns, technology choices
- **Quality Standards**: Code quality, testing requirements, acceptance criteria
- **Strategic Direction**: Feature priorities, pivot decisions, roadmap changes
- **Cross-System Integration**: How components interact with existing systems

### CCPM Controls
- **Implementation Details**: File structure, coding patterns, specific algorithms
- **Parallel Coordination**: Agent work distribution, conflict resolution, scheduling
- **Progress Tracking**: Status updates, GitHub sync, milestone reporting
- **Routine Validation**: Automated testing, linting, build processes, CI/CD
- **Git Workflow**: Branching, commits, merges, worktree management

## Integration Patterns

### For New Features
```
1. Strategic Planning:
   User defines need → Orchestrator analyzes → Architecture decisions → PRD creation

2. CCPM Execution:
   PRD → Epic decomposition → Parallel implementation → Testing → GitHub sync

3. Quality Review:
   Orchestrator validates → User approves → Integration → Next iteration planning
```

### For Bug Fixes
```
Small/Routine Bugs: Direct CCPM execution with /pm:issue-start
Complex Bugs: Orchestrator analysis → Root cause → CCPM implementation → Review
```

### For Refactoring
```
Strategic Refactoring: Orchestrator plans → Architecture review → CCPM execution  
Code Cleanup: Direct CCPM with parallel-worker coordination
```

## Practical Examples

### Example 1: Major Feature Addition
```
Scenario: Add real-time notifications to Storacle

Strategic Phase:
User: "We need real-time notifications for data changes"
├── Orchestrator analyzes: WebSocket vs Server-Sent Events vs Polling
├── Architecture decision: WebSocket with fallback, event-driven design
├── Salesforce integration: Platform Events vs Change Data Capture
└── PRD created with technical specifications

Execution Phase:
├── /pm:prd-parse "realtime-notifications"
├── Parallel streams: WebSocket server, client handlers, Salesforce events, testing
└── CCPM manages implementation across multiple work streams

Review Phase:
├── Orchestrator validates architecture compliance
├── Performance and scalability testing
└── User acceptance and go-live decision
```

### Example 2: Technical Debt Resolution
```
Scenario: Refactor data access layer for better performance

Strategic Phase:
├── Orchestrator analyzes current bottlenecks
├── Architecture decision: Repository pattern with caching strategy  
└── Migration strategy with zero-downtime requirements

Execution Phase:
├── CCPM coordinates: Interface definition, repository implementations, cache layer, tests
└── Parallel execution with careful dependency management

Review Phase:
├── Performance benchmarking validation
├── Integration testing with existing systems
└── Rollout plan approval
```

## Benefits

### Strategic Benefits
- **Better Decisions**: Human oversight on architecture and design choices
- **Quality Control**: Rigorous review processes and acceptance criteria
- **Risk Management**: Human validation of complex technical decisions
- **Strategic Alignment**: Features align with business objectives

### Execution Benefits  
- **Parallel Efficiency**: Multiple work streams executing simultaneously
- **Automated Tracking**: GitHub integration with progress visibility
- **Consistent Process**: Standardized workflows and quality checks
- **Context Optimization**: Agents handle implementation details without overwhelming main conversation

### Combined Benefits
- **Scalability**: Handle complex projects with multiple parallel work streams
- **Quality**: Strategic oversight ensures good architectural decisions
- **Efficiency**: Automated execution handles routine implementation work
- **Visibility**: Clear project status and progress tracking throughout

## Implementation Guidelines

### When to Use Orchestrator
- Architecture and design decisions
- Technology selection and trade-offs
- Complex problem analysis requiring multiple perspectives
- Quality gates and milestone reviews
- Cross-system integration planning
- Strategic direction changes

### When to Use CCPM
- Implementation of well-defined designs
- Parallel execution of independent work streams
- Routine testing and validation workflows
- Progress tracking and status reporting
- Git workflow management
- Automated build and deployment processes

### Escalation Patterns
- **CCPM → Orchestrator**: When implementation reveals architectural issues
- **Orchestrator → User**: When strategic decisions require business input
- **Either → Problem Queue**: When technical blockers need resolution

This hybrid model provides the strategic rigor needed for good technical decisions while leveraging automation for efficient execution and project management.