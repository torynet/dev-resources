# Commit Hooks Troubleshooting Guide

Complete troubleshooting guide for Git commit hooks, covering installation issues, validation problems, and platform-specific complications.

## Table of Contents

- [Quick Diagnostics](#quick-diagnostics)
- [Installation Issues](#installation-issues)
- [Validation Problems](#validation-problems)
- [Platform-Specific Issues](#platform-specific-issues)
- [Performance Issues](#performance-issues)
- [Emergency Procedures](#emergency-procedures)
- [Detailed Diagnostics](#detailed-diagnostics)

## Quick Diagnostics

### Health Check Script

Run this quick diagnostic to identify common issues:

```bash
#!/bin/bash
# Hook health check script

echo "=== Git Commit Hook Health Check ==="

# Check Git repository
echo -n "Git repository: "
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "✅ Valid Git repository"
    GIT_DIR=$(git rev-parse --git-dir)
    echo "   Git directory: $GIT_DIR"
else
    echo "❌ Not a Git repository or Git not available"
    exit 1
fi

# Check hook file exists
HOOK_FILE="$GIT_DIR/hooks/commit-msg"
echo -n "Hook file: "
if [ -f "$HOOK_FILE" ]; then
    echo "✅ Found at $HOOK_FILE"
else
    echo "❌ Not found at $HOOK_FILE"
fi

# Check hook permissions
echo -n "Hook permissions: "
if [ -x "$HOOK_FILE" ]; then
    echo "✅ Executable"
else
    echo "❌ Not executable"
    echo "   Fix with: chmod +x $HOOK_FILE"
fi

# Check hook script validity
echo -n "Hook script syntax: "
if bash -n "$HOOK_FILE" 2>/dev/null; then
    echo "✅ Valid bash syntax"
else
    echo "❌ Syntax errors found"
fi

# Test hook execution
echo -n "Hook execution test: "
echo "test: validation check" > /tmp/test-commit-msg
if "$HOOK_FILE" /tmp/test-commit-msg 2>/dev/null; then
    echo "✅ Hook executes successfully"
else
    echo "❌ Hook execution failed"
fi

# Check branch name for issue extraction
BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")
echo "Current branch: $BRANCH"
if [[ "$BRANCH" =~ ([0-9]+) ]]; then
    echo "✅ Issue number detected: ${BASH_REMATCH[1]}"
else
    echo "ℹ️  No issue number in branch name"
fi

echo "=== Health Check Complete ==="
```

### Quick Fix Commands

```bash
# Reinstall hooks
./scripts/install-salesforce-hooks.sh --force

# Fix permissions
chmod +x .git/hooks/commit-msg

# Test hook manually
echo "feat: test message" | .git/hooks/commit-msg /dev/stdin

# Emergency bypass
git commit --no-verify -m "emergency commit"
```

## Installation Issues

### Issue: Hook Script Not Found

**Symptoms:**

```
[ERROR] Hook script not found at ./scripts/commit-msg
```

**Diagnosis:**

```bash
# Check current directory
pwd
ls -la scripts/

# Check for alternative locations
find . -name "commit-msg" -type f
```

**Solutions:**

1. **Ensure correct project root:**

   ```bash
   # Navigate to project root
   cd $(git rev-parse --show-toplevel)
   ls scripts/commit-msg
   ```

2. **Check worktree configuration:**

   ```bash
   # If in a worktree, check main repository
   git worktree list
   # Navigate to main worktree for installation
   ```

3. **Verify files are tracked in Git:**

   ```bash
   git ls-files scripts/
   git status scripts/
   ```

### Issue: Permission Denied on Linux/macOS

**Symptoms:**

```
bash: ./scripts/install-salesforce-hooks.sh: Permission denied
```

**Solutions:**

1. **Make installation script executable:**

   ```bash
   chmod +x scripts/install-salesforce-hooks.sh
   chmod +x scripts/commit-msg
   ```

2. **Check file ownership:**

   ```bash
   ls -la scripts/install-salesforce-hooks.sh
   # If needed, fix ownership:
   sudo chown $USER:$USER scripts/install-salesforce-hooks.sh
   ```

3. **Alternative execution method:**

   ```bash
   bash scripts/install-salesforce-hooks.sh
   ```

### Issue: PowerShell Execution Policy (Windows)

**Symptoms:**

```
cannot be loaded because running scripts is disabled on this system
```

**Solutions:**

1. **Check current policy:**

   ```powershell
   Get-ExecutionPolicy
   ```

2. **Set policy for current user:**

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Bypass for single execution:**

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\install-hooks.ps1
   ```

4. **Use unblock command:**

   ```powershell
   Unblock-File .\scripts\install-hooks.ps1
   ```

### Issue: Git Directory Not Found

**Symptoms:**

```
[ERROR] Not in a Git repository.
```

**Solutions:**

1. **Initialize Git repository:**

   ```bash
   git init
   ```

2. **Check if inside .git directory:**

   ```bash
   pwd
   # Navigate out of .git directory
   cd ..
   ```

3. **Verify Git installation:**

   ```bash
   git --version
   which git
   ```

4. **Check for corrupted Git repository:**

   ```bash
   git fsck
   ```

## Validation Problems

### Issue: Valid Commits Being Rejected

**Symptoms:**

```
[COMMIT-MSG] Invalid conventional commit format!
```

**Diagnosis:**

```bash
# Test hook with known good message
echo "feat: test message" > /tmp/test-commit
.git/hooks/commit-msg /tmp/test-commit
echo "Exit code: $?"

# Check exact commit message format
git show --format="%s" --no-patch HEAD
```

**Common Format Issues:**

1. **Missing space after colon:**

   ```bash
   # Wrong
   "feat:add new feature"
   # Correct  
   "feat: add new feature"
   ```

2. **Invalid commit type:**

   ```bash
   # Wrong
   "feature: add new feature"
   # Correct
   "feat: add new feature"
   ```

3. **Wrong capitalization:**

   ```bash
   # Wrong
   "Feat: Add new feature"
   # Correct
   "feat: add new feature"
   ```

4. **Description too long:**

   ```bash
   # Check line length
   echo "feat: your very long commit message here" | wc -c
   # Should be under 72 characters for first line
   ```

### Issue: Issue Number Not Being Injected

**Symptoms:**

- Commits don't include "Issue #XXX" reference
- Branch has issue number but it's not detected

**Diagnosis:**

```bash
# Check current branch name
git branch --show-current

# Test issue extraction manually
BRANCH="feature/123-test"
if [[ "$BRANCH" =~ ([0-9]+) ]]; then
    echo "Found issue: ${BASH_REMATCH[1]}"
else
    echo "No issue found in: $BRANCH"
fi
```

**Solutions:**

1. **Fix branch naming:**

   ```bash
   # Rename branch to include issue number
   git branch -m feature/123-descriptive-name
   ```

2. **Supported branch patterns:**

   ```bash
   feature/123-description    # ✅ Extracts 123
   bugfix/456-fix-name       # ✅ Extracts 456  
   hotfix/789-urgent         # ✅ Extracts 789
   docs/101-documentation    # ✅ Extracts 101
   feature-123-description   # ❌ No extraction
   feature/description-123   # ✅ Extracts 123 (last number)
   ```

3. **Manual issue reference:**

   ```bash
   # If auto-injection fails, add manually
   git commit -m "feat: implement new feature

   Issue #123"
   ```

### Issue: Breaking Change Detection Not Working

**Symptoms:**

- Breaking changes not detected for semantic versioning
- Footer syntax not recognized

**Solutions:**

1. **Use correct footer syntax:**

   ```bash
   git commit -m "feat: new feature with breaking change

   BREAKING CHANGE: removed support for old API format"
   ```

2. **Use exclamation mark syntax:**

   ```bash
   git commit -m "feat!: remove deprecated endpoints"
   ```

3. **Verify in commit message:**

   ```bash
   git show --format="%B" --no-patch HEAD | grep -i "breaking"
   ```

## Platform-Specific Issues

### Windows Issues

#### Issue: Line Ending Problems

**Symptoms:**

```
bash: $'\r': command not found
```

**Solutions:**

1. **Check file line endings:**

   ```bash
   file .git/hooks/commit-msg
   # Should show "ASCII text" not "ASCII text, with CRLF line terminators"
   ```

2. **Convert line endings:**

   ```bash
   # Using dos2unix
   dos2unix .git/hooks/commit-msg
   
   # Using sed
   sed -i 's/\r$//' .git/hooks/commit-msg
   
   # Using PowerShell
   (Get-Content .git\hooks\commit-msg) -join "`n" | Set-Content .git\hooks\commit-msg
   ```

3. **Configure Git for line endings:**

   ```bash
   git config core.autocrlf false
   git config core.eol lf
   ```

#### Issue: Path Separator Problems

**Symptoms:**

```
No such file or directory: ./scripts\commit-msg
```

**Solutions:**

1. **Use forward slashes in scripts:**

   ```bash
   # Update script paths to use forward slashes
   ./scripts/commit-msg  # Not .\scripts\commit-msg
   ```

2. **Use PowerShell-native paths:**

   ```powershell
   Join-Path $PSScriptRoot "commit-msg"
   ```

#### Issue: Bash Not Available

**Symptoms:**

```
bash: command not found
```

**Solutions:**

1. **Install Git Bash:**
   - Download from git-scm.com
   - Includes bash shell for Windows

2. **Use WSL (Windows Subsystem for Linux):**

   ```bash
   wsl bash scripts/install-salesforce-hooks.sh
   ```

3. **Use PowerShell version:**

   ```powershell
   .\scripts\install-hooks.ps1
   ```

### macOS Issues

#### Issue: Shebang Not Working

**Symptoms:**

```
bad interpreter: No such file or directory
```

**Solutions:**

1. **Check bash location:**

   ```bash
   which bash
   # Update shebang if needed: #!/usr/bin/bash or #!/bin/bash
   ```

2. **Use env for portability:**

   ```bash
   # Change shebang to:
   #!/usr/bin/env bash
   ```

3. **Install newer bash:**

   ```bash
   brew install bash
   # Then use: #!/usr/local/bin/bash
   ```

#### Issue: Permission Issues with System Integrity Protection

**Symptoms:**

```
Operation not permitted
```

**Solutions:**

1. **Avoid system directories:**

   ```bash
   # Install in user space, not system locations
   ```

2. **Check SIP status:**

   ```bash
   csrutil status
   ```

3. **Use homebrew paths:**

   ```bash
   export PATH="/usr/local/bin:$PATH"
   ```

### Linux Issues

#### Issue: Different Bash Versions

**Symptoms:**

```
syntax error near unexpected token
```

**Solutions:**

1. **Check bash version:**

   ```bash
   bash --version
   # Minimum required: bash 3.2
   ```

2. **Update bash:**

   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install bash
   
   # CentOS/RHEL
   sudo yum update bash
   
   # Alpine
   apk add --update bash
   ```

3. **Use compatible syntax:**

   ```bash
   # Avoid bash 4+ features in hooks
   # Use POSIX-compatible alternatives
   ```

## Performance Issues

### Issue: Hook Execution is Slow

**Symptoms:**

- Commits take several seconds to complete
- Hook appears to hang

**Diagnosis:**

```bash
# Time hook execution
time .git/hooks/commit-msg /tmp/test-commit-msg

# Check for network calls
strace -e trace=network .git/hooks/commit-msg /tmp/test-commit-msg 2>&1 | grep -i connect

# Check for file system issues
strace -e trace=file .git/hooks/commit-msg /tmp/test-commit-msg 2>&1 | grep -E "(open|read|write)"
```

**Solutions:**

1. **Disable network dependencies:**

   ```bash
   # Comment out GitHub CLI calls if they're slow
   # sed -i 's/gh .*/# &/' .git/hooks/commit-msg
   ```

2. **Optimize file operations:**

   ```bash
   # Check for unnecessary file reads
   # Optimize grep patterns
   # Use built-in bash operations instead of external commands
   ```

3. **Add timeout protection:**

   ```bash
   # Wrap slow operations with timeout
   timeout 5s gh issue view "$ISSUE_NUMBER" || true
   ```

### Issue: Large Repository Impact

**Symptoms:**

- Hook slow in repositories with many commits
- Memory usage high during hook execution

**Solutions:**

1. **Limit history scanning:**

   ```bash
   # Don't scan entire commit history
   # Focus only on current commit
   ```

2. **Use shallow operations:**

   ```bash
   # Avoid operations that require full history
   git log --max-count=1
   ```

3. **Cache frequently accessed data:**

   ```bash
   # Cache issue validation results
   # Store temporary data in .git/hooks-cache/
   ```

## Emergency Procedures

### Complete Hook Bypass

When hooks are completely broken and preventing work:

```bash
# Method 1: Temporary bypass
git commit --no-verify -m "emergency: bypass broken hook"

# Method 2: Disable hook temporarily
mv .git/hooks/commit-msg .git/hooks/commit-msg.disabled
git commit -m "emergency: commit without hook"
mv .git/hooks/commit-msg.disabled .git/hooks/commit-msg

# Method 3: Use emergency prefix
git commit -m "EMERGENCY: critical fix needed immediately"
```

### Hook Recovery

After emergency situation is resolved:

```bash
# Reinstall hooks
./scripts/install-salesforce-hooks.sh --force

# Verify installation
echo "test: recovery verification" | .git/hooks/commit-msg /dev/stdin

# Test normal commit
git commit --amend -m "fix: resolve emergency issue properly"
```

### Rollback Previous Commits

If commits were made with broken hooks:

```bash
# Check recent commits
git log --oneline -5

# Interactive rebase to fix commit messages
git rebase -i HEAD~3

# For each commit, change 'pick' to 'reword' and fix the message
```

## Detailed Diagnostics

### Environment Information Collection

Create a diagnostic report:

```bash
#!/bin/bash
# Hook diagnostic report generator

echo "=== Git Commit Hook Diagnostic Report ==="
echo "Generated: $(date)"
echo

echo "--- System Information ---"
uname -a
echo

echo "--- Git Information ---"
git --version
git config --list | grep -E "(user|core)" | head -10
echo

echo "--- Repository Information ---"
git rev-parse --show-toplevel
git rev-parse --git-dir
git branch --show-current
echo

echo "--- Hook Information ---"
ls -la .git/hooks/commit-msg 2>/dev/null || echo "Hook not found"
echo

echo "--- File Permissions ---"
ls -la scripts/ 2>/dev/null || echo "Scripts directory not found"
echo

echo "--- Environment Variables ---"
env | grep -E "(GIT|PATH|SHELL)" | head -10
echo

echo "--- Hook Content (first 20 lines) ---"
head -20 .git/hooks/commit-msg 2>/dev/null || echo "Cannot read hook file"
echo

echo "--- Recent Commits ---"
git log --oneline -5 2>/dev/null || echo "Cannot read commit history"
echo

echo "=== End Diagnostic Report ==="
```

### Log Analysis

Enable detailed logging in the hook:

```bash
# Add to hook for debugging
exec 2>> ~/.git-hook-debug.log
set -x
echo "Hook started at $(date)" >&2
```

View the logs:

```bash
tail -f ~/.git-hook-debug.log
```

### Network Connectivity Testing

Test GitHub connectivity:

```bash
# Test basic connectivity
ping -c 3 github.com

# Test HTTPS access
curl -I https://api.github.com

# Test GitHub CLI
gh auth status
gh api user
```

## Getting Help

### Creating Support Tickets

When reporting issues, include:

1. **Diagnostic report** (from script above)
2. **Exact error messages** (copy/paste)
3. **Steps to reproduce** the problem
4. **Platform information** (OS, shell, Git version)
5. **Hook version/commit** you're using

### Community Resources

- **Project Repository**: GitHub issues and discussions
- **Git Documentation**: Official Git hooks documentation
- **Conventional Commits**: conventionalcommits.org
- **Stack Overflow**: Search for "git hooks" + your specific error

### Debug Mode Activation

For persistent issues, enable debug mode:

```bash
# Add debug flags to hook
export DEBUG_COMMIT_HOOK=1
export COMMIT_HOOK_VERBOSE=1

# Run commit with debug output
git commit -m "debug: test commit with verbose output"
```

This comprehensive troubleshooting guide should help resolve most issues encountered with the commit hook system.
