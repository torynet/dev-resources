● Claude Code Epic-GitHub Synchronization Repair Instructions (Complete)

  Problem Overview

  When using Claude Code Project Management (CCPM) workflows, epic and task synchronization between
  local files and GitHub issues can become inconsistent. Common issues include:
  - Epic issues on GitHub containing only summary stats instead of full epic content
  - Task issues missing complete content from their local .md files
  - Missing sub-issue parent-child relationships between epics and tasks
  - Mismatch between local file content (source of truth) and GitHub issue content
  - Broken or incomplete task linking in GitHub Projects

  Prerequisites

  - GitHub CLI (gh) installed and authenticated
  - gh-sub-issue extension installed: gh extension install yahsan2/gh-sub-issue
  - Access to the project repository with admin permissions
  - Local .claude/epics/ directory structure intact

  Step-by-Step Repair Process

  Phase 1: Audit Local Files (Source of Truth)

  1. Map all epic directories and files:
  find .claude/epics -name "epic.md" | sort

  2. Extract GitHub references from all epic files:
  for epic in .claude/epics/*/epic.md; do
    epic_name=$(dirname "$epic" | sed 's|.claude/epics/||')
    echo "=== $epic_name ==="
    grep -E "^github:|^- \[.*\].*#[0-9]+" "$epic" || echo "No GitHub references found"
    echo
  done

  3. List all task files in each epic:
  find .claude/epics -name "*.md" -not -name "epic.md" -not -name "github-mapping.md" | sort -V

  4. Document the expected issue mapping:
    - Record which epic should map to which GitHub issue numbers
    - Record which task files should map to which sub-issue numbers
    - Note any missing or inconsistent numbering

  Phase 2: Compare GitHub vs Local State

  5. Get complete GitHub issue list:
  gh issue list --repo OWNER/REPO --limit 100 --json number,title,state --jq 'sort_by(.number) | .[] |      
  "\(.number): \(.title) [\(.state)]"'

  6. Identify missing or incorrect issues:
    - Compare GitHub issue list with expected local file mappings
    - Note any missing issues, incorrect titles, or wrong numbering
    - Verify all epic and task issues exist with correct numbers

  Phase 3: Update Epic Issues with Complete Content

  7. Check if epic issues have full content:
  for epic_num in 1 9 17 25 32; do  # Replace with your actual epic issue numbers
    echo "=== Epic #$epic_num ==="
    gh issue view $epic_num --repo OWNER/REPO --json body --jq '.body' | head -10
    echo
  done

  8. Update epic issues with complete local content:
  # For each epic, update with the full epic.md file content
  gh issue edit 1 --repo OWNER/REPO --body-file .claude/epics/project-foundation/epic.md
  gh issue edit 9 --repo OWNER/REPO --body-file .claude/epics/core-object-model/epic.md
  gh issue edit 17 --repo OWNER/REPO --body-file .claude/epics/discovery-service/epic.md
  gh issue edit 25 --repo OWNER/REPO --body-file .claude/epics/measurement-service/epic.md
  gh issue edit 32 --repo OWNER/REPO --body-file .claude/epics/engine/epic.md
  # Add more as needed for your project

  Phase 4: Update Task Issues with Complete Content

  9. Check if task issues have full content:
  # Check a sample task issue
  gh issue view 2 --repo OWNER/REPO --json body --jq '.body' | head -10

  10. Update all task issues with complete local content:

  Generic approach for all epics:
  # For each epic directory, update all task issues with their full .md content
  for epic_dir in .claude/epics/*/; do
    epic_name=$(basename "$epic_dir")
    echo "=== Updating $epic_name task issues ==="

    # Find all numbered .md files (task files) in the epic directory
    find "$epic_dir" -name "[0-9]*.md" | sort -V | while read task_file; do
      # Extract issue number from filename
      issue_num=$(basename "$task_file" .md)

      echo "Updating issue #$issue_num with content from $task_file..."
      gh issue edit "$issue_num" --repo OWNER/REPO --body-file "$task_file" || echo "Failed to update       
  #$issue_num"
    done
    echo
  done

  Or specific approach by epic:
  # Update project-foundation tasks (issues #2-8)
  for i in 2 3 4 5 6 7 8; do
    echo "Updating issue #$i with content from .claude/epics/project-foundation/$i.md..."
    gh issue edit $i --repo OWNER/REPO --body-file ".claude/epics/project-foundation/$i.md"
  done

  # Update core-object-model tasks (issues #10-16)
  for i in 10 11 12 13 14 15 16; do
    echo "Updating issue #$i with content from .claude/epics/core-object-model/$i.md..."
    gh issue edit $i --repo OWNER/REPO --body-file ".claude/epics/core-object-model/$i.md"
  done

  # Update discovery-service tasks (issues #18-24)
  for i in 18 19 20 21 22 23 24; do
    echo "Updating issue #$i with content from .claude/epics/discovery-service/$i.md..."
    gh issue edit $i --repo OWNER/REPO --body-file ".claude/epics/discovery-service/$i.md"
  done

  # Update measurement-service tasks (issues #26-31)
  for i in 26 27 28 29 30 31; do
    echo "Updating issue #$i with content from .claude/epics/measurement-service/$i.md..."
    gh issue edit $i --repo OWNER/REPO --body-file ".claude/epics/measurement-service/$i.md"
  done

  # Update engine tasks (issues #33-38)
  for i in 33 34 35 36 37 38; do
    echo "Updating issue #$i with content from .claude/epics/engine/$i.md..."
    gh issue edit $i --repo OWNER/REPO --body-file ".claude/epics/engine/$i.md"
  done

  Phase 5: Establish Sub-Issue Relationships

  11. Check gh-sub-issue extension:
  gh extension list | grep sub-issue
  # If not installed: gh extension install yahsan2/gh-sub-issue

  12. Link task issues to their parent epics:

  For project-foundation (epic #1, tasks #2-8):
  for i in 2 3 4 5 6 7 8; do
    echo "Linking #$i to epic #1..."
    gh sub-issue add 1 $i --repo OWNER/REPO || echo "Failed to link #$i - may already be linked"
  done

  For core-object-model (epic #9, tasks #10-16):
  for i in 10 11 12 13 14 15 16; do
    echo "Linking #$i to epic #9..."
    gh sub-issue add 9 $i --repo OWNER/REPO || echo "Failed to link #$i - may already be linked"
  done

  For discovery-service (epic #17, tasks #18-24):
  for i in 18 19 20 21 22 23 24; do
    echo "Linking #$i to epic #17..."
    gh sub-issue add 17 $i --repo OWNER/REPO || echo "Failed to link #$i - may already be linked"
  done

  For measurement-service (epic #25, tasks #26-31):
  for i in 26 27 28 29 30 31; do
    echo "Linking #$i to epic #25..."
    gh sub-issue add 25 $i --repo OWNER/REPO || echo "Failed to link #$i - may already be linked"
  done

  For engine (epic #32, tasks #33-38):
  for i in 33 34 35 36 37 38; do
    echo "Linking #$i to epic #32..."
    gh sub-issue add 32 $i --repo OWNER/REPO || echo "Failed to link #$i - may already be linked"
  done

  Note: Adjust the epic and task number ranges based on your project's actual issue numbering.

  Phase 6: Verification

  13. Verify epic issues have complete content and task links:
  # Check that epic issues now show task lists
  gh issue view 1 --repo OWNER/REPO --json body --jq '.body' | grep -E "#[0-9]+" | head -10
  gh issue view 9 --repo OWNER/REPO --json body --jq '.body' | grep -E "#[0-9]+" | head -10
  # Repeat for other epics

  14. Verify task issues have complete content:
  # Check that task issues now have full content
  gh issue view 2 --repo OWNER/REPO --json body --jq '.body' | head -20
  gh issue view 10 --repo OWNER/REPO --json body --jq '.body' | head -20
  # Should show full task descriptions, acceptance criteria, etc.

  15. Verify sub-issue relationships are established:
  # Check that issues are properly linked (this will show in the GitHub UI)
  gh issue view 2 --repo OWNER/REPO  # Should show parent epic relationship
  gh issue view 10 --repo OWNER/REPO # Should show parent epic relationship

  Common Issues and Solutions

  Issue: "Sub issue may only have one parent" Error

  Cause: Task issue is already linked to a different parent epicSolution:
  - Check which epic the task is currently linked to: gh issue view TASK_NUM --repo OWNER/REPO
  - Remove incorrect relationship: gh sub-issue remove WRONG_PARENT TASK_NUM --repo OWNER/REPO
  - Add correct relationship: gh sub-issue add CORRECT_PARENT TASK_NUM --repo OWNER/REPO

  Issue: "Duplicate sub-issues" Error

  Cause: Task is already linked to the correct parentSolution: This is actually success - the
  relationship already exists correctly

  Issue: Missing Task Issues

  Cause: Task issues were never created or were deletedSolution: Re-run the appropriate /pm:epic-sync       
  command to recreate missing issues

  Issue: Wrong Issue Numbers

  Cause: Issues were created out of sequence or gaps existSolution: You may need to:
  1. Close and delete incorrect issues (carefully!)
  2. Re-run epic sync to recreate with correct numbering
  3. Update all local references to match new numbers

  Issue: Task Issues Have No Body Content

  Cause: The CCPM sync process only creates issues with titles but doesn't upload full contentSolution:     
   Use Phase 4 above to update all task issues with their complete .md file content

  Generic Template

  For any CCMP project, adapt this template:

  # Replace these variables with your project specifics
  REPO="OWNER/REPO_NAME"
  EPIC_DIRS=(".claude/epics/epic1" ".claude/epics/epic2" ".claude/epics/epic3")
  EPIC_ISSUES=(1 5 10)  # GitHub issue numbers for epics
  TASK_RANGES=("2 3 4" "6 7 8 9" "11 12 13")  # Task issue ranges for each epic

  # Update all epic issues with local content
  for i in "${!EPIC_DIRS[@]}"; do
    epic_dir="${EPIC_DIRS[$i]}"
    epic_issue="${EPIC_ISSUES[$i]}"
    gh issue edit $epic_issue --repo $REPO --body-file "$epic_dir/epic.md"
  done

  # Update all task issues with local content
  for epic_dir in .claude/epics/*/; do
    find "$epic_dir" -name "[0-9]*.md" | sort -V | while read task_file; do
      issue_num=$(basename "$task_file" .md)
      gh issue edit "$issue_num" --repo $REPO --body-file "$task_file"
    done
  done

  # Link all task issues to their parent epics
  for i in "${!EPIC_ISSUES[@]}"; do
    epic_issue="${EPIC_ISSUES[$i]}"
    task_range="${TASK_RANGES[$i]}"
    for task in $task_range; do
      echo "Linking #$task to epic #$epic_issue..."
      gh sub-issue add $epic_issue $task --repo $REPO || echo "Failed to link #$task"
    done
  done

  Verification Checklist

  - All epic issues exist on GitHub with correct numbers
  - All task issues exist on GitHub with correct numbers
  - Epic issues contain complete content from local epic.md files
  - Task issues contain complete content from local task .md files
  - Epic issues display task lists with proper issue number links
  - All task issues show parent epic relationships in GitHub UI
  - No "orphaned" task issues without parent relationships
  - GitHub Projects board shows proper epic/task hierarchy (if using Projects)

  Prevention

  To avoid these issues in the future:
  1. Always use /pm:epic-sync commands rather than manual issue creation
  2. After running /pm:epic-sync, manually verify that task issues have complete content
  3. Don't manually edit GitHub issue content - keep local files as source of truth
  4. Regular verification: find .claude/epics -name "*.md" | wc -l should match GitHub issue count
  5. Use GitHub Projects to visualize epic/task relationships and catch broken links early

  ---