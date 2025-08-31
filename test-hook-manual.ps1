# Test the regex pattern manually
$branchName = "feature/123-auth"
if ($branchName -match "^[^/]+/(\d+)(?:-.*)?$") {
    Write-Host "✓ Extracted issue ID: $($Matches[1])" -ForegroundColor Green
} else {
    Write-Host "✗ No match" -ForegroundColor Red
}

# Test more patterns
$testBranches = @("dev/456", "hotfix/789-security", "bugfix/101", "feature/202-dashboard", "main", "random-branch")
foreach ($branch in $testBranches) {
    if ($branch -match "^[^/]+/(\d+)(?:-.*)?$") {
        Write-Host "✓ $branch → Issue #$($Matches[1])" -ForegroundColor Green
    } elseif ($branch -eq "main" -or $branch -eq "master") {
        Write-Host "ℹ $branch → Main branch (no issue ID)" -ForegroundColor Cyan
    } else {
        Write-Host "⚠ $branch → No match" -ForegroundColor Yellow
    }
}