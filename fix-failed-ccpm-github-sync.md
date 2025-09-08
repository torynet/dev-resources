# Claude Code Epic-GitHub Synchronization Repair Instructions (Generic)

## Problem Overview

When using Claude Code Project Management (CCPM) workflows, epic and task synchronization between local files and GitHub issues can become inconsistent. Common issues include:
- Epic issues on GitHub containing only summary stats instead of full epic content
- Task issues missing complete content from their local .md files
- Missing sub-issue parent-child relationships between epics and tasks
- Mismatch between local file content (source of truth) and GitHub issue content
- Broken or incomplete task linking in GitHub Projects

## Prerequisites

- GitHub CLI (gh) installed and authenticated
- gh-sub-issue extension installed: `gh extension install yahsan2/gh-sub-issue`
- Access to the project repository with admin permissions
- Local `.claude/epics/` directory structure intact

## Step-by-Step Repair Process

### Phase 1: Audit Local Files (Source of Truth)

1. **Map all epic directories and files:**
   ```bash
   find .claude/epics -name "epic.md" | sort
   ```

2. **Extract GitHub references from all epic files:**
   ```bash
   for epic in .claude/epics/*/epic.md; do
     epic_name=$(dirname "$epic" | sed 's|.claude/epics/||')
     echo "=== $epic_name ==="
     grep -E "^github:|^- \[.*\].*#[0-9]+" "$epic" || echo "No GitHub references found"
     echo
   done
   ```

3. **List all task files in each epic:**
   ```bash
   find .claude/epics -name "*.md" -not -name "epic.md" -not -name "github-mapping.md" | sort -V
   ```

4. **Document the expected issue mapping:**
   - Record which epic should map to which GitHub issue numbers
   - Record which task files should map to which sub-issue numbers
   - Note any missing or inconsistent numbering

### Phase 2: Compare GitHub vs Local State

5. **Get complete GitHub issue list:**
   ```bash
   gh issue list --repo OWNER/REPO --limit 100 --json number,title,state --jq 'sort_by(.number) | .[] | "\(.number): \(.title) [\(.state)]"'
   ```

6. **Identify missing or incorrect issues:**
   - Compare GitHub issue list with expected local file mappings
   - Note any missing issues, incorrect titles, or wrong numbering
   - Verify all epic and task issues exist with correct numbers

### Phase 3: Update Epic Issues with Complete Content

7. **Check if epic issues have full content:**
   ```bash
   # Replace with your actual epic issue numbers
   for epic_num in EPIC_ISSUE_NUMBERS; do
     echo "=== Epic #$epic_num ==="
     gh issue view $epic_num --repo OWNER/REPO --json body --jq '.body' | head -10
     echo
   done
   ```

8. **Update epic issues with complete local content:**
   ```bash
   # Generic approach for all epics
   for epic_dir in .claude/epics/*/; do
     epic_name=$(basename "$epic_dir")
     epic_file="$epic_dir/epic.md"
     
     if [ -f "$epic_file" ]; then
       # Extract GitHub issue number from epic.md file
       epic_issue_num=$(grep "^github:" "$epic_file" | sed 's/github:.*#//' || echo "")
       
       if [ -n "$epic_issue_num" ]; then
         echo "Updating epic issue #$epic_issue_num with content from $epic_file..."
         gh issue edit $epic_issue_num --repo OWNER/REPO --body-file "$epic_file"
       else
         echo "No GitHub issue number found for $epic_name"
       fi
     fi
   done
   ```

### Phase 4: Update Task Issues with Complete Content

9. **Check if task issues have full content:**
   ```bash
   # Check a sample task issue (replace with actual task issue number)
   gh issue view TASK_ISSUE_NUMBER --repo OWNER/REPO --json body --jq '.body' | head -10
   ```

10. **Update all task issues with complete local content:**
    ```bash
    # Generic approach for all epics
    for epic_dir in .claude/epics/*/; do
      epic_name=$(basename "$epic_dir")
      echo "=== Updating $epic_name task issues ==="

      # Find all numbered .md files (task files) in the epic directory
      find "$epic_dir" -name "[0-9]*.md" | sort -V | while read task_file; do
        # Extract issue number from filename
        issue_num=$(basename "$task_file" .md)

        echo "Updating issue #$issue_num with content from $task_file..."
        gh issue edit "$issue_num" --repo OWNER/REPO --body-file "$task_file" || echo "Failed to update #$issue_num"
      done
      echo
    done
    ```

### Phase 5: Establish Sub-Issue Relationships

11. **Check gh-sub-issue extension:**
    ```bash
    gh extension list | grep sub-issue
    # If not installed: gh extension install yahsan2/gh-sub-issue
    ```

12. **Link task issues to their parent epics:**
    ```bash
    # Generic approach
    for epic_dir in .claude/epics/*/; do
      epic_name=$(basename "$epic_dir")
      epic_file="$epic_dir/epic.md"
      
      if [ -f "$epic_file" ]; then
        # Extract epic issue number
        epic_issue_num=$(grep "^github:" "$epic_file" | sed 's/github:.*#//' || echo "")
        
        if [ -n "$epic_issue_num" ]; then
          echo "=== Linking tasks to epic #$epic_issue_num ($epic_name) ==="
          
          # Find all task files and link them
          find "$epic_dir" -name "[0-9]*.md" | sort -V | while read task_file; do
            task_num=$(basename "$task_file" .md)
            echo "Linking #$task_num to epic #$epic_issue_num..."
            gh sub-issue add $epic_issue_num $task_num --repo OWNER/REPO || echo "Failed to link #$task_num - may already be linked"
          done
        fi
      fi
    done
    ```

### Phase 6: Verification

13. **Verify epic issues have complete content and task links:**
    ```bash
    # Check that epic issues now show task lists
    for epic_dir in .claude/epics/*/; do
      epic_file="$epic_dir/epic.md"
      if [ -f "$epic_file" ]; then
        epic_issue_num=$(grep "^github:" "$epic_file" | sed 's/github:.*#//' || echo "")
        if [ -n "$epic_issue_num" ]; then
          echo "=== Epic #$epic_issue_num content preview ==="
          gh issue view $epic_issue_num --repo OWNER/REPO --json body --jq '.body' | head -10
          echo
        fi
      fi
    done
    ```

14. **Verify task issues have complete content:**
    ```bash
    # Check sample task issues have full content
    find .claude/epics -name "[0-9]*.md" | head -5 | while read task_file; do
      issue_num=$(basename "$task_file" .md)
      echo "=== Task #$issue_num content preview ==="
      gh issue view $issue_num --repo OWNER/REPO --json body --jq '.body' | head -10
      echo
    done
    ```

15. **Verify sub-issue relationships are established:**
    ```bash
    # Check sample issues for parent relationships
    find .claude/epics -name "[0-9]*.md" | head -3 | while read task_file; do
      issue_num=$(basename "$task_file" .md)
      echo "=== Checking relationships for #$issue_num ==="
      gh issue view $issue_num --repo OWNER/REPO | grep -E "(Parent|Child|Sub)" || echo "No relationships shown"
      echo
    done
    ```

## Project-Specific Configuration Template

Replace these variables with your project specifics:

```bash
# Project configuration
REPO="OWNER/REPO_NAME"

# Update all epic issues with local content
for epic_dir in .claude/epics/*/; do
  epic_file="$epic_dir/epic.md"
  if [ -f "$epic_file" ]; then
    epic_issue_num=$(grep "^github:" "$epic_file" | sed 's/github:.*#//' || echo "")
    if [ -n "$epic_issue_num" ]; then
      gh issue edit $epic_issue_num --repo $REPO --body-file "$epic_file"
    fi
  fi
done

# Update all task issues with local content
for epic_dir in .claude/epics/*/; do
  find "$epic_dir" -name "[0-9]*.md" | sort -V | while read task_file; do
    issue_num=$(basename "$task_file" .md)
    gh issue edit "$issue_num" --repo $REPO --body-file "$task_file"
  done
done

# Link all task issues to their parent epics
for epic_dir in .claude/epics/*/; do
  epic_file="$epic_dir/epic.md"
  if [ -f "$epic_file" ]; then
    epic_issue_num=$(grep "^github:" "$epic_file" | sed 's/github:.*#//' || echo "")
    if [ -n "$epic_issue_num" ]; then
      find "$epic_dir" -name "[0-9]*.md" | sort -V | while read task_file; do
        task_num=$(basename "$task_file" .md)
        gh sub-issue add $epic_issue_num $task_num --repo $REPO || echo "Link may already exist"
      done
    fi
  fi
done
```

## Common Issues and Solutions

### Issue: "Sub issue may only have one parent" Error
- **Cause:** Task issue is already linked to a different parent epic
- **Solution:**
  - Check current parent: `gh issue view TASK_NUM --repo OWNER/REPO`
  - Remove incorrect link: `gh sub-issue remove WRONG_PARENT TASK_NUM --repo OWNER/REPO`
  - Add correct link: `gh sub-issue add CORRECT_PARENT TASK_NUM --repo OWNER/REPO`

### Issue: "Duplicate sub-issues" Error
- **Cause:** Task is already linked to the correct parent
- **Solution:** This is actually success - the relationship already exists correctly

### Issue: Missing Task Issues
- **Cause:** Task issues were never created or were deleted
- **Solution:** Re-run the appropriate `/pm:epic-sync` command to recreate missing issues

### Issue: Wrong Issue Numbers
- **Cause:** Issues were created out of sequence or gaps exist
- **Solution:** 
  1. Close and delete incorrect issues (carefully!)
  2. Re-run epic sync to recreate with correct numbering
  3. Update all local references to match new numbers

### Issue: Task Issues Have No Body Content
- **Cause:** The CCPM sync process only creates issues with titles but doesn't upload full content
- **Solution:** Use Phase 4 above to update all task issues with their complete .md file content

## Verification Checklist

- [ ] All epic issues exist on GitHub with correct numbers
- [ ] All task issues exist on GitHub with correct numbers
- [ ] Epic issues contain complete content from local epic.md files
- [ ] Task issues contain complete content from local task .md files
- [ ] Epic issues display task lists with proper issue number links
- [ ] All task issues show parent epic relationships in GitHub UI
- [ ] No "orphaned" task issues without parent relationships
- [ ] GitHub Projects board shows proper epic/task hierarchy (if using Projects)

## Prevention

To avoid these issues in the future:
1. Always use `/pm:epic-sync` commands rather than manual issue creation
2. After running `/pm:epic-sync`, manually verify that task issues have complete content
3. Don't manually edit GitHub issue content - keep local files as source of truth
4. Regular verification: `find .claude/epics -name "*.md" | wc -l` should match GitHub issue count
5. Use GitHub Projects to visualize epic/task relationships and catch broken links early

## Quick Commands Summary

```bash
# Get project overview
find .claude/epics -name "*.md" | sort -V
gh issue list --repo OWNER/REPO --limit 50 --json number,title

# Update all content
for epic_dir in .claude/epics/*/; do
  # Update epic
  epic_file="$epic_dir/epic.md"
  if [ -f "$epic_file" ]; then
    epic_num=$(grep "^github:" "$epic_file" | sed 's/github:.*#//')
    [ -n "$epic_num" ] && gh issue edit $epic_num --repo OWNER/REPO --body-file "$epic_file"
  fi
  
  # Update tasks
  find "$epic_dir" -name "[0-9]*.md" | while read task_file; do
    task_num=$(basename "$task_file" .md)
    gh issue edit $task_num --repo OWNER/REPO --body-file "$task_file"
  done
done

# Link all relationships
for epic_dir in .claude/epics/*/; do
  epic_file="$epic_dir/epic.md"
  epic_num=$(grep "^github:" "$epic_file" | sed 's/github:.*#//' 2>/dev/null)
  if [ -n "$epic_num" ]; then
    find "$epic_dir" -name "[0-9]*.md" | while read task_file; do
      task_num=$(basename "$task_file" .md)
      gh sub-issue add $epic_num $task_num --repo OWNER/REPO 2>/dev/null
    done
  fi
done
```