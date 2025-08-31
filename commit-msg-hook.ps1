#!/usr/bin/env pwsh
# Git commit-msg hook for adding GitHub issue IDs
# Extracts issue IDs from branches: {prefix}/{issue-id} or {prefix}/{issue-id}-{description}
# Examples: dev/123, hotfix/456-patch, feature/789-dashboard

param(
    [string]$CommitMsgFile
)

# Read the commit message
$commitMessage = Get-Content -Path $CommitMsgFile -Raw
$commitMessage = $commitMessage.Trim()

# Skip if commit message is empty or starts with # (comment)
if ([string]::IsNullOrWhiteSpace($commitMessage) -or $commitMessage.StartsWith("#")) {
    exit 0
}

# Skip if message already has an issue ID pattern at the start
if ($commitMessage -match "^#?\d+:\s") {
    exit 0
}

# Skip for merge commits, revert commits, etc.
if ($commitMessage -match "^(Merge|Revert|fixup!|squash!)") {
    exit 0
}

# Get current branch name
$branchName = git branch --show-current
$issueId = $null

# Extract issue ID from {prefix}/{issue-id} or {prefix}/{issue-id}-{description} pattern
if ($branchName -match "^[^/]+/(\d+)(?:-.*)?$") {
    $issueId = $Matches[1]
    
    # Add issue ID to commit message
    $newCommitMessage = "#${issueId}: $commitMessage"
    Set-Content -Path $CommitMsgFile -Value $newCommitMessage -NoNewline
    
    Write-Host "✓ Added issue #${issueId} to commit message (from branch: $branchName)" -ForegroundColor Green
} elseif ($branchName -eq "main" -or $branchName -eq "master") {
    # On main/master branches, proceed without modification
    Write-Host "ℹ On main branch - no issue ID added" -ForegroundColor Cyan
} else {
    # Not on a proper branch pattern - warn user
    Write-Host "⚠ Branch doesn't match pattern {prefix}/{issue-id}. Current branch: $branchName" -ForegroundColor Yellow
    Write-Host "  Examples: dev/123, hotfix/456, feature/789-description" -ForegroundColor Gray
}

exit 0