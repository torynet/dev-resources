# Software Project Design Process

This document describes a comprehensive process for designing complex software
systems through iterative documentation, analysis, and refinement. This process
was developed and refined during the Storacle project design phase.

## Process Overview

This is a **design-first, documentation-driven** approach that emphasizes
thorough planning and architectural thinking before implementation. The process
produces a complete set of design documents that serve as both specification
and implementation guide.

## Phase 1: Project Foundation

### 1.1 Initial Planning Documentation
- **Create project repository** with clear folder structure (`docs/` for all design documents)
- **Write comprehensive README.md** explaining project purpose, scope, and goals
- **Create index.md** as central documentation hub with table of contents linking all documents
- **Create plan.md** with overall project timeline, phases, and major milestones
- **Document core principles.md** establishing design philosophy and architectural guidelines
- **Define features.md** with detailed feature specifications and business requirements

### 1.2 Architecture Conceptualization
- **Design core concepts.md** explaining key processes, workflows, and system behavior
- **Create architectural diagrams** (Mermaid preferred) showing system components and relationships
- **Define processing pipelines** with clear phase prioritization and error handling strategies
- **Establish data flow patterns** and integration points

## Phase 2: Object Model Design

### 2.1 High-Level Object Design
- **Create object model diagram** showing all entities and relationships
- **Define object purposes** with clear single-responsibility descriptions
- **Establish relationship patterns** (Master-Detail vs Lookup decisions)
- **Document data lifecycle** and retention strategies

### 2.2 Field-by-Field Object Review
**Critical Process**: Conduct systematic review of each object:

1. **Object Introduction**
   - Read object purpose and description
   - Review current field specifications
   - Identify potential issues or improvements

2. **Field-by-Field Analysis**
   - **Critical Process**: Review ONE field at a time, wait for user feedback before proceeding
   - Present current field specification exactly as documented
   - Wait for user input on changes before making modifications
   - After user feedback, update documentation to reflect changes AND ensure it follows document standards
   - Only then proceed to next field
   - Review format for each field:
     - **Current Specification**: Exact current definition from documentation
     - **Purpose Analysis**: Why this field exists and how it's used (if user requests analysis)
     - **User Feedback**: Changes requested by user
     - **Final Specification**: Updated specification with proper documentation format
   
3. **Cross-Field Optimization**
   - Identify redundant or low-utility fields
   - Consolidate related functionality
   - Ensure consistent patterns across objects
   - Validate field relationships and dependencies

4. **Documentation Updates**
   - Update object-model.md with refined specifications
   - Include complete field tables with: Label, Type, Required, Default, Description, Help Text
   - Remove deprecated fields and update indexes/relationships

### 2.3 Iterative Refinement
- **Question assumptions** during review process
- **Simplify complexity** by removing over-engineered features
- **Focus on high-utility features** that provide clear business value
- **Maintain future extensibility** without current complexity

## Phase 3: Decision Documentation

### 3.1 Comprehensive Decision Recording
**For every significant decision**, document in decisions.md:
- **Decision statement** (what was decided)
- **Rationale** (detailed reasoning with bullet points)
- **Implementation approach** (how it will work)
- **Alternatives considered** (other options evaluated)
- **Why alternatives were rejected** (specific reasoning)

### 3.2 Decision Categories
- **Architecture Decisions**: System structure, processing patterns, integration approaches
- **Object Model Decisions**: Relationship types, field designs, data patterns
- **Technical Implementation Decisions**: Technology choices, algorithm approaches, performance strategies
- **User Experience Decisions**: Interface patterns, workflow designs, administrative features

## Phase 4: Supporting Documentation

### 4.1 Outstanding Questions Management
- **Create outstanding-questions.md** for implementation research items
- **Document technical unknowns** that require verification during implementation
- **Include context, impact, and resolution plans** for each question
- **Reference sources** and links where applicable

### 4.2 Future Ideas Capture
- **Create future-ideas.md** for enhancements beyond current scope
- **Document advanced features** that could be valuable in later phases
- **Include technical requirements** and business value for each idea
- **Preserve architectural extensibility** for future enhancements

### 4.3 Todo Management
- **Use TodoWrite tool** for short-term task tracking during design sessions
- **Use GitHub Projects** for all long-term task management and collaboration
- **Planning Integration**: Use 'plan' labeled tasks in GitHub Projects to track and order planning steps during design phase
- **Status Synchronization**: Planning-level todos from TodoWrite should sync to GitHub Projects with appropriate status mapping (pending→Todo, in_progress→In Progress, completed→Done)
- **Task Ordering**: Maintain proper ordering of planning cards to reflect project phase progression
- **Focus Clarity**: Sync only high-level planning items, not operational details or implementation steps
- **Avoid duplicate plan-todo.md files** - GitHub Projects is the single source of truth
- **Categorize todos** by phase, complexity, and dependencies with appropriate labels
- **Update status regularly** as work progresses

## Phase 5: Version Control & Collaboration

### 5.1 Git Workflow
- **Use descriptive branch names** (e.g., `planning`, `design`, `object-model-review`)
- **Make frequent, focused commits** with comprehensive commit messages
- **Commit related changes together** (e.g., all docs updated for single decision)
- **Use detailed commit messages** explaining what was accomplished and why

### 5.2 Commit Message Format
```
Brief summary of changes (50 chars max)

Detailed description of what was changed:
- Category 1: Specific changes made
- Category 2: Additional changes
- Category 3: Related updates

Technical details:
- Implementation notes
- Architecture decisions
- Object model changes

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Phase 6: Quality Assurance

### 6.1 Design Validation
- **Cross-reference all documents** for consistency
- **Validate decision alignment** across different documents
- **Check for missing edge cases** and error scenarios
- **Ensure complete object specifications** with all required fields

### 6.2 Architectural Review
- **Verify future extensibility** without current over-engineering
- **Confirm scalability patterns** and performance considerations
- **Validate security and data integrity** approaches
- **Review integration points** and external dependencies

## Key Process Principles

### Documentation-Driven Design
- **Write before building** - complete specifications before implementation
- **Think through edge cases** during design rather than during coding
- **Capture rationale** for all decisions to aid future maintenance
- **Maintain living documents** that evolve with understanding

### Iterative Refinement
- **Question everything** during review process
- **Simplify complexity** wherever possible
- **Focus on business value** over technical elegance
- **Preserve optionality** for future decisions

### Collaborative Decision Making
- **Document alternatives thoroughly** for informed decision making
- **Explain reasoning clearly** for future team members
- **Provide implementation guidance** beyond just architectural decisions
- **Create audit trails** for architectural evolution

## Tools and Technologies

### Documentation Tools
- **Markdown** for all documentation (GitHub Flavored Markdown)
- **Mermaid** for architectural and process diagrams
- **GitHub Projects** for external task management and collaboration
- **Git** for version control with detailed commit history

### Analysis Techniques
- **Field-by-field review** for detailed object analysis
- **Alternative analysis** for comprehensive decision making
- **Cross-document validation** for consistency checking
- **Structured questioning** to challenge assumptions

## Success Metrics

### Design Quality Indicators
- **Comprehensive documentation** covering all major decisions
- **Consistent patterns** across similar components
- **Clear implementation guidance** for development team
- **Minimal outstanding questions** before implementation begins

### Process Effectiveness
- **Reduced implementation surprises** due to thorough design
- **Faster onboarding** of new team members through clear documentation
- **Easier maintenance** due to documented decision rationale
- **Successful architectural evolution** guided by extensibility planning

## Adaptation Guidelines

### Process Customization
- **Adjust documentation depth** based on project complexity
- **Modify review processes** for team size and expertise
- **Adapt tool choices** for organizational preferences
- **Scale decision documentation** appropriately for project scope

### Process Evolution
- **Update this document** as new techniques are discovered
- **Capture lessons learned** from each project application
- **Refine templates and formats** based on effectiveness
- **Share improvements** across projects and teams

---

*This process document should be updated as new techniques are discovered and existing processes are refined. It serves as both a guide for current projects and a foundation for continuous process improvement.*