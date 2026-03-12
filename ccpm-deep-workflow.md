# CCPM Deep Workflow Guide

## Quick Reference

**For Salesforce projects (Review Mode):**
```bash
/pm:epic-start-worktree-deep pipeline
/pm:issue-pr-epic 62         # Create PR to epic branch
# Review & merge PR via GitHub
/pm:issue-mark-complete 62   # Clean up & continue
```

**For infrastructure projects (Trust Mode):**
```bash
/pm:epic-start-worktree-deep infrastructure
# Let Claude work...
git diff main..epic/infrastructure  # Review epic branch
/pm:epic-merge-deep infrastructure  # Merge all
```

---

## Overview

The CCMP Deep Workflow provides two distinct approaches for managing epic development based on trust level and project complexity:

- **Review Mode**: PR-per-issue workflow for projects requiring careful review (e.g., Salesforce)
- **Trust Mode**: Bulk workflow for projects where speed is prioritized over granular review

## When to Use Each Mode

### Review Mode: PR-per-Issue (Careful Review)
**Use when:**
- Working with Salesforce development (metadata, configurations)
- Complex business logic requiring validation
- Multiple developers need visibility into changes
- You want to understand exactly what Claude is doing
- Code quality gates are important

**Benefits:**
- Granular control over what gets merged
- Opportunity to request changes before integration
- Better understanding of Claude's work
- Incremental integration reduces risk

### Trust Mode: Bulk Integration (Speed Priority)
**Use when:**
- Infrastructure setup or documentation
- Projects where you trust Claude's expertise
- Speed is more important than review overhead
- Low-risk changes that can be easily reverted

**Benefits:**
- Faster development cycles
- Less review overhead
- Bulk integration of related changes
- Focus on outcomes rather than process

---

## Review Mode: PR-per-Issue Workflow

*For Salesforce and other high-oversight projects*

### Step 1: Start Epic with Deep Mode
```bash
/pm:epic-start-worktree-deep <epic_name>
```

**What this does:**
- Creates or switches to epic branch: `epic/<epic_name>`
- Identifies ready issues (no unmet dependencies)
- Creates isolated issue worktrees: `../issue-62/`, `../issue-63/`, etc.
- Launches Claude agents in separate worktrees (no file conflicts possible)

**Example:**
```bash
/pm:epic-start-worktree-deep pipeline
```

### Step 2: Monitor Progress
```bash
/pm:epic-status-deep <epic_name>
```

**What to look for:**
- Which issues are actively being worked on
- Which agents are running in which worktrees
- Completion status of individual issues

### Step 3: Create PR When Issue Completes

**Choose your integration strategy:**

#### Option A: PR to Epic Branch (Recommended)
```bash
/pm:issue-pr-epic <issue_number>
```
- Integrates issue into epic branch first
- Maintains epic as coordination point
- Better for complex epics with dependencies

#### Option B: PR Directly to Main
```bash
/pm:issue-pr-main <issue_number>
```
- Bypasses epic integration
- Faster for independent issues
- Use when epic coordination not needed

**What both commands do:**
- Validates issue worktree is in completed state
- Pushes issue branch to GitHub
- Creates pull request with proper title and description
- Updates issue status to 'review'
- Provides PR URL for review

**Example:**
```bash
/pm:issue-pr-epic 62
# Creates PR: "Issue #62: Commit Hook System" → epic/pipeline

/pm:issue-pr-main 62  
# Creates PR: "Issue #62: Commit Hook System" → main
```

### Step 4: Review the Pull Request

**Review Focus Areas:**
- **Salesforce Metadata**: Proper field types, validation rules, permissions
- **Business Logic**: Correct implementation of requirements
- **Code Quality**: Naming conventions, error handling, testing
- **Integration**: How changes affect existing functionality

**Actions:**
- ✅ **Approve and merge** if satisfied
- 🔄 **Request changes** if issues found
- 💬 **Comment** on specific lines for clarification

### Step 5: Mark Issue Complete
```bash
/pm:issue-mark-complete <issue_number>
```

**What this does:**
- Verifies PR was merged via GitHub
- Updates issue status to 'done' with completion timestamp
- Cleans up issue worktree and merged branch
- Identifies newly unblocked issues that can start next
- Shows epic progress toward completion

**Example:**
```bash
/pm:issue-mark-complete 62
# Shows: "Issue #61 is now ready to start"
```

### Step 6: Continue with Next Issues

**Check what's ready:**
```bash
/pm:epic-status-deep pipeline
```

**Start newly unblocked issues** (Claude will automatically pick up where it left off)

### Step 7: Complete Epic
When all issues are done:
```bash
/pm:epic-merge-deep <epic_name>
```

---

## Trust Mode: Bulk Integration Workflow

*For infrastructure, documentation, and trusted domains*

### Step 1: Start Epic with Deep Mode
```bash
/pm:epic-start-worktree-deep <epic_name>
```

Same as Review Mode - switches to epic branch and creates isolated issue worktrees for safety even in trust mode.

### Step 2: Let Claude Work
Monitor occasionally:
```bash
/pm:epic-status-deep <epic_name>
```

But don't interrupt the flow - let Claude complete the entire epic.

### Step 3: Review Final Result
```bash
# Review epic branch changes
git log --oneline epic/<epic_name>
git diff main..epic/<epic_name>
```

**Review the consolidated changes:**
- Overall approach and architecture
- Final deliverable quality
- Documentation completeness

### Step 4: Merge Epic When Satisfied
```bash
/pm:epic-merge-deep <epic_name>
```

**What this does:**
- Merges all completed issues to main branch
- Cleans up all worktrees and branches
- Updates epic status to complete

---

## Key Differences Summary

| Aspect | Review Mode (PR-per-Issue) | Trust Mode (Bulk Integration) |
|--------|-------------------------|------------------------|
| **Review Granularity** | Every issue individually | Entire epic at once |
| **Control** | High - can reject specific changes | Medium - accept/reject whole epic |
| **Speed** | Slower due to review overhead | Faster - minimal interruption |
| **Understanding** | Deep - see every change | High-level - see final outcome |
| **Risk** | Low - incremental validation | Medium - bulk validation |
| **Best For** | Salesforce, business logic | Infrastructure, docs |

---

## Common Commands Reference

### Deep Mode Commands
- `/pm:epic-start-worktree-deep <epic>` - Start epic with issue isolation
- `/pm:epic-status-deep <epic>` - Show detailed progress across all issues
- `/pm:epic-merge-deep <epic>` - Merge completed epic to main

### Issue Management (Review Mode)
- `/pm:issue-pr-epic <number>` - Create PR to epic branch (recommended)
- `/pm:issue-pr-main <number>` - Create PR directly to main branch
- `/pm:issue-mark-complete <number>` - Mark issue done after PR merge
- `/pm:issue-status <number>` - Check individual issue progress

### Monitoring
- `/pm:epic-status <epic>` - Basic epic progress
- `git worktree list` - See all active worktrees
- `cd ../issue-<number> && git log` - Review issue work

---

## Troubleshooting

### Issue Worktree Not Found
```bash
# Check available worktrees
ls -d ../issue-* 

# Restart specific issue if needed
/pm:issue-start-worktree <number>
```

### PR Creation Fails
```bash
# Ensure GitHub CLI is authenticated
gh auth status

# Check if branch was pushed
cd ../issue-<number>
git status
git log --oneline
```

### Epic Won't Merge
```bash
# Check for incomplete issues
/pm:epic-status-deep <epic>

# Ensure all issues are marked complete
/pm:issue-mark-complete <number>
```

### Worktree Cleanup Issues
```bash
# Manual cleanup if automated cleanup fails
git worktree list
git worktree remove ../issue-<number>
git branch -d epic-<epic>-issue-<number>
```

