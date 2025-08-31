#!/bin/bash
# Git commit-msg hook for adding GitHub issue IDs
# This script automatically prepends issue IDs to commit messages

COMMIT_MSG_FILE="$1"

# Read the commit message
commit_message=$(cat "$COMMIT_MSG_FILE" | sed '/^#/d' | sed '/^$/d' | head -1)

# Skip if commit message is empty
if [[ -z "$commit_message" ]]; then
    exit 0
fi

# Skip if message already has an issue ID pattern at the start
if [[ "$commit_message" =~ ^#?[0-9]+:\ ]]; then
    exit 0
fi

# Skip for merge commits, revert commits, etc.
if [[ "$commit_message" =~ ^(Merge|Revert|fixup!|squash!) ]]; then
    exit 0
fi

# Try to extract issue ID from current branch name
branch_name=$(git branch --show-current)
issue_id=""

# Pattern 1: issue-123, issue/123, 123-feature-name
if [[ "$branch_name" =~ (issue[-/]?)?([0-9]+) ]]; then
    issue_id="${BASH_REMATCH[2]}"
# Pattern 2: feature/123-description, bugfix/456-something  
elif [[ "$branch_name" =~ (feature|bugfix|hotfix)[-/]([0-9]+) ]]; then
    issue_id="${BASH_REMATCH[2]}"
fi

# If no issue ID found in branch name, check environment variable
if [[ -z "$issue_id" ]] && [[ -n "$ISSUE_ID" ]]; then
    issue_id="$ISSUE_ID"
fi

# If still no issue ID, look for it in the commit message body
if [[ -z "$issue_id" ]] && [[ "$commit_message" =~ #([0-9]+) ]]; then
    issue_id="${BASH_REMATCH[1]}"
fi

# If we found an issue ID, prepend it to the commit message
if [[ -n "$issue_id" ]]; then
    # Read the full commit message (including comments for editing)
    full_message=$(cat "$COMMIT_MSG_FILE")
    
    # Replace the first non-comment line with the prefixed version
    echo "$full_message" | sed "0,/^[^#]/{s/^[^#].*/#$issue_id: $commit_message/}" > "$COMMIT_MSG_FILE"
    
    echo "✓ Added issue #$issue_id to commit message"
else
    echo "⚠ No issue ID detected. Set ISSUE_ID environment variable or use branch naming convention."
    echo "  Branch patterns: issue-123, feature/123-name, 123-feature-name"
fi

exit 0