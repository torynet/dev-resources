# GitHub Actions Debug and Iteration Script
# Usage: .\gh-action-debug.ps1 -Branch "epic-pipeline-issue-64" -Repo "Syndacon/storacle"

param(
    [Parameter(Mandatory = $true)]
    [string]$Branch,
    
    [Parameter(Mandatory = $false)]
    [string]$Repo = "",
    
    [Parameter(Mandatory = $false)]
    [int]$MaxIterations = 10,
    
    [Parameter(Mandatory = $false)]
    [int]$WaitSeconds = 60,
    
    [Parameter(Mandatory = $false)]
    [switch]$AnalyzeOnly
)

# Auto-detect repo if not provided
if (-not $Repo) {
    try {
        $repoInfo = gh repo view --json owner,name | ConvertFrom-Json
        $Repo = "$($repoInfo.owner.login)/$($repoInfo.name)"
        Write-Host "✅ Auto-detected repo: $Repo" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Could not auto-detect repo. Please specify -Repo parameter" -ForegroundColor Red
        exit 1
    }
}

function Get-LatestRun {
    param($Branch, $Repo)
    
    try {
        $runs = gh run list --repo $Repo --branch $Branch --limit 1 --json databaseId,status,conclusion,workflowName,createdAt,url | ConvertFrom-Json
        if ($runs.Count -eq 0) {
            return $null
        }
        return $runs[0]
    }
    catch {
        Write-Host "❌ Error fetching runs: $_" -ForegroundColor Red
        return $null
    }
}

function Get-FailedRunLogs {
    param($RunId, $Repo)
    
    Write-Host "📋 Fetching failure logs for run $RunId..." -ForegroundColor Yellow
    try {
        $logs = gh run view $RunId --repo $Repo --log-failed
        return $logs
    }
    catch {
        Write-Host "❌ Error fetching logs: $_" -ForegroundColor Red
        return ""
    }
}

function Analyze-Failures {
    param($Logs)
    
    Write-Host "`n🔍 FAILURE ANALYSIS" -ForegroundColor Cyan
    Write-Host "===================" -ForegroundColor Cyan
    
    # Common failure patterns
    $patterns = @{
        "File not found" = "file|directory.*not found|no such file"
        "Permission denied" = "permission denied|access denied|unauthorized"
        "Syntax error" = "syntax error|unexpected token|invalid syntax"
        "Missing dependency" = "command not found|module not found|package not found"
        "Environment issue" = "environment variable|secret.*not found"
        "Network/timeout" = "timeout|connection refused|network.*error"
        "YAML/workflow error" = "invalid workflow|yaml.*error|workflow.*error"
    }
    
    $foundIssues = @()
    foreach ($pattern in $patterns.GetEnumerator()) {
        if ($Logs -match $pattern.Value) {
            $foundIssues += $pattern.Key
            Write-Host "⚠️  Detected: $($pattern.Key)" -ForegroundColor Yellow
        }
    }
    
    if ($foundIssues.Count -eq 0) {
        Write-Host "ℹ️  No common patterns detected - manual review needed" -ForegroundColor Blue
    }
    
    Write-Host "`n📝 FULL LOGS:" -ForegroundColor Cyan
    Write-Host "=============" -ForegroundColor Cyan
    Write-Host $Logs
    
    return $foundIssues
}

function Wait-ForUserAction {
    Write-Host "`n🔧 NEXT STEPS:" -ForegroundColor Green
    Write-Host "1. Review the failure analysis above"
    Write-Host "2. Make necessary fixes to your code/workflows"
    Write-Host "3. Commit and push your changes"
    Write-Host "4. Press ENTER to continue monitoring, or Ctrl+C to exit"
    Read-Host
}

# Main execution loop
Write-Host "🚀 GitHub Actions Debug Script" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green
Write-Host "Repo: $Repo"
Write-Host "Branch: $Branch"
Write-Host "Max Iterations: $MaxIterations"
Write-Host ""

$iteration = 0
$lastRunId = $null

while ($iteration -lt $MaxIterations) {
    $iteration++
    Write-Host "`n🔄 Iteration $iteration of $MaxIterations" -ForegroundColor Magenta
    Write-Host "===========================================" -ForegroundColor Magenta
    
    # Get latest run
    $latestRun = Get-LatestRun -Branch $Branch -Repo $Repo
    
    if (-not $latestRun) {
        Write-Host "❌ No runs found for branch $Branch" -ForegroundColor Red
        break
    }
    
    Write-Host "📊 Latest Run Info:" -ForegroundColor Blue
    Write-Host "  ID: $($latestRun.databaseId)"
    Write-Host "  Workflow: $($latestRun.workflowName)"
    Write-Host "  Status: $($latestRun.status)"
    Write-Host "  Conclusion: $($latestRun.conclusion)"
    Write-Host "  Created: $($latestRun.createdAt)"
    Write-Host "  URL: $($latestRun.url)"
    
    # Skip if same run as last iteration
    if ($latestRun.databaseId -eq $lastRunId) {
        Write-Host "⏳ Same run as last check - waiting $WaitSeconds seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds $WaitSeconds
        continue
    }
    
    $lastRunId = $latestRun.databaseId
    
    # Handle different run states
    switch ($latestRun.status) {
        "in_progress" {
            Write-Host "⏳ Run is still in progress - waiting $WaitSeconds seconds..." -ForegroundColor Yellow
            Start-Sleep -Seconds $WaitSeconds
            continue
        }
        "queued" {
            Write-Host "📋 Run is queued - waiting $WaitSeconds seconds..." -ForegroundColor Yellow
            Start-Sleep -Seconds $WaitSeconds
            continue
        }
        "completed" {
            if ($latestRun.conclusion -eq "success") {
                Write-Host "✅ Run completed successfully!" -ForegroundColor Green
                Write-Host "🎉 All workflows are now passing on branch $Branch" -ForegroundColor Green
                break
            }
            elseif ($latestRun.conclusion -eq "failure") {
                Write-Host "❌ Run failed - analyzing..." -ForegroundColor Red
                
                # Get and analyze failure logs
                $logs = Get-FailedRunLogs -RunId $latestRun.databaseId -Repo $Repo
                $issues = Analyze-Failures -Logs $logs
                
                if ($AnalyzeOnly) {
                    Write-Host "`n✅ Analysis complete (AnalyzeOnly mode)" -ForegroundColor Green
                    break
                }
                
                # Wait for user to fix issues
                Wait-ForUserAction
            }
            else {
                Write-Host "⚠️  Run completed with conclusion: $($latestRun.conclusion)" -ForegroundColor Yellow
                Wait-ForUserAction
            }
        }
        default {
            Write-Host "❓ Unknown run status: $($latestRun.status)" -ForegroundColor Yellow
            Start-Sleep -Seconds $WaitSeconds
        }
    }
}

if ($iteration -ge $MaxIterations) {
    Write-Host "`n⏰ Reached maximum iterations ($MaxIterations)" -ForegroundColor Yellow
    Write-Host "You can run the script again to continue monitoring"
}

Write-Host "`n🏁 Debug session completed" -ForegroundColor Green