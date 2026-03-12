# Git Commit Hooks Installation Guide

This guide covers the installation and setup of Git commit hooks for Salesforce development workflows. These hooks enforce conventional commit standards and automatically inject GitHub issue numbers from branch names.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Platform-Specific Installation](#platform-specific-installation)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)

## Overview

The commit hook system provides:

- **Conventional Commit Validation**: Enforces standardized commit message format
- **Automatic Issue Injection**: Extracts GitHub issue numbers from branch names and adds them to commit messages
- **Breaking Change Detection**: Identifies commits that introduce breaking changes for semantic versioning
- **Cross-Platform Support**: Works on Windows, macOS, and Linux

### Supported Commit Types

| Type | Description | Version Impact |
|------|-------------|----------------|
| `feat` | New features | Minor version bump |
| `fix` | Bug fixes | Patch version bump |
| `docs` | Documentation changes | No version bump |
| `style` | Code style changes | No version bump |
| `refactor` | Code refactoring | No version bump |
| `test` | Adding or updating tests | No version bump |
| `chore` | Maintenance tasks | No version bump |
| `perf` | Performance improvements | No version bump |
| `ci` | CI/CD changes | No version bump |
| `build` | Build system changes | No version bump |
| `revert` | Reverting previous commits | No version bump |

### Breaking Changes

Breaking changes can be indicated in two ways:

1. **Footer syntax**: Include `BREAKING CHANGE: description` in the commit footer
2. **Type syntax**: Add `!` after the type/scope (e.g., `feat!: new breaking feature`)

Breaking changes trigger a **major version bump**.

## Prerequisites

### Required Dependencies

1. **Git**: Repository must be Git-initialized
2. **Bash/Shell Environment**:
   - **Linux/macOS**: bash 3.2+ (usually pre-installed)
   - **Windows**: Git Bash, WSL, or MSYS2
3. **PowerShell** (Windows only): PowerShell 5.1+ or PowerShell Core 7+

### Optional Dependencies

- **GitHub CLI (gh)**: For enhanced issue validation (recommended but not required)
- **Node.js**: For potential future enhancements

### Repository Requirements

- Active Git repository
- GitHub repository with issue tracking enabled (for auto-injection feature)
- Proper branch naming convention (e.g., `feature/123-description`)

## Platform-Specific Installation

### Linux and macOS

```bash
# Navigate to your project root
cd /path/to/your/project

# Run the installation script
./scripts/install-salesforce-hooks.sh
```

#### Installation Options

```bash
# Force installation (overwrite existing hooks)
./scripts/install-salesforce-hooks.sh --force

# Show help
./scripts/install-salesforce-hooks.sh --help

# Uninstall hooks
./scripts/install-salesforce-hooks.sh --uninstall
```

### Windows

#### Option 1: PowerShell (Recommended)

```powershell
# Navigate to your project root
cd C:\path\to\your\project

# Run the PowerShell installation script
.\scripts\install-hooks.ps1
```

#### PowerShell Installation Options

```powershell
# Force installation (overwrite existing hooks)
.\scripts\install-hooks.ps1 -Force

# Show help
.\scripts\install-hooks.ps1 -Help

# Uninstall hooks
.\scripts\install-hooks.ps1 -Uninstall
```

#### Option 2: Git Bash

```bash
# Open Git Bash and navigate to your project
cd /c/path/to/your/project

# Run the bash installation script
./scripts/install-salesforce-hooks.sh
```

## Verification

### Test Installation

1. **Verify hook is installed**:

   ```bash
   ls -la .git/hooks/commit-msg
   ```

   You should see the commit-msg hook file.

2. **Test with a valid commit**:

   ```bash
   git add .
   git commit -m "feat: add user authentication system"
   ```

   This should succeed and show validation messages.

3. **Test with an invalid commit**:

   ```bash
   git commit -m "added some stuff"
   ```

   This should fail with a helpful error message.

### Issue Auto-Injection Test

1. **Create a feature branch**:

   ```bash
   git checkout -b feature/123-user-authentication
   ```

2. **Make a commit**:

   ```bash
   git commit -m "feat: implement OAuth integration"
   ```

3. **Check the commit message**:

   ```bash
   git log --oneline -1
   ```

   The commit should automatically include "Issue #123" reference.

### Expected Output

**Successful Installation**:

```
[INFO] Platform: Linux
[INFO] Checking Git repository...
[SUCCESS] Git repository validated (git-dir: /path/to/project/.git)
[INFO] Checking hook script availability...
[SUCCESS] Hook script found
[INFO] Installing commit-msg hook...
[SUCCESS] Hook installed successfully
[SUCCESS] Installation completed!

[INFO] The commit-msg hook is now active and will:
  • Validate conventional commit format (feat:, fix:, etc.)
  • Auto-inject GitHub issue numbers from branch names
  • Enforce breaking change detection
```

**Successful Commit Validation**:

```
[COMMIT-MSG] Validating commit message...
[COMMIT-MSG] Auto-injected issue #123 reference
[COMMIT-MSG] Commit message validation passed
```

## Troubleshooting

### Common Issues

#### 1. "Hook script not found" Error

**Problem**: Installation script can't find the commit-msg hook file.

**Solution**:

```bash
# Ensure you're in the project root
pwd
ls scripts/commit-msg

# If missing, check if you're in a worktree or submodule
git rev-parse --show-toplevel
```

#### 2. "Not in a Git repository" Error

**Problem**: Running installation outside a Git repository.

**Solution**:

```bash
# Initialize Git repository if needed
git init

# Or navigate to existing repository
cd /path/to/git/repo
```

#### 3. Permission Denied (Linux/macOS)

**Problem**: Hook script doesn't have execute permissions.

**Solution**:

```bash
# Make the installation script executable
chmod +x scripts/install-salesforce-hooks.sh

# Re-run installation
./scripts/install-salesforce-hooks.sh
```

#### 4. PowerShell Execution Policy (Windows)

**Problem**: PowerShell blocks script execution.

**Solution**:

```powershell
# Check current execution policy
Get-ExecutionPolicy

# Temporarily allow script execution (run as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or run with bypass
powershell -ExecutionPolicy Bypass -File .\scripts\install-hooks.ps1
```

#### 5. Commit Validation Failing

**Problem**: Valid commits are being rejected.

**Debugging Steps**:

```bash
# Check the exact error message
git commit -m "test: debug message" -v

# Test hook manually
echo "feat: test message" | .git/hooks/commit-msg /dev/stdin

# Check hook log output
tail -f ~/.git/hooks/commit-msg.log  # if logging is enabled
```

#### 6. Issue Auto-Injection Not Working

**Problem**: Branch names with issue numbers don't auto-inject.

**Debugging**:

```bash
# Check current branch name
git branch --show-current

# Test branch name pattern
echo "feature/123-test" | grep -o '[0-9]\+'

# Verify hook can extract issue number
bash -c 'BRANCH="feature/123-test"; [[ "$BRANCH" =~ ([0-9]+) ]] && echo "Found: ${BASH_REMATCH[1]}"'
```

### Advanced Troubleshooting

#### Enable Debug Mode

Temporarily modify the commit-msg hook for debugging:

```bash
# Edit the hook to add debug output
nano .git/hooks/commit-msg

# Add at the top after the shebang:
set -x  # Enable debug tracing
```

#### Check Hook Dependencies

```bash
# Verify bash is available
which bash

# Check bash version
bash --version

# Test Git configuration
git config --list | grep -E "(user|core)"
```

#### Validate Hook Execution

```bash
# Test hook manually with a sample message
echo "feat: test commit message" > /tmp/test-commit-msg
.git/hooks/commit-msg /tmp/test-commit-msg
echo $?  # Should be 0 for success
```

### Recovery Procedures

#### Bypass Hook in Emergency

```bash
# Use EMERGENCY prefix to bypass validation
git commit -m "EMERGENCY: critical production fix"

# Or use --no-verify flag
git commit --no-verify -m "emergency fix"
```

#### Restore Previous Hooks

```bash
# If backups were created during installation
ls .git/hooks-backup/

# Restore original hooks
cp .git/hooks-backup/commit-msg .git/hooks/commit-msg
```

## Uninstallation

### Remove Hooks

**Linux/macOS**:

```bash
./scripts/install-salesforce-hooks.sh --uninstall
```

**Windows PowerShell**:

```powershell
.\scripts\install-hooks.ps1 -Uninstall
```

### Manual Removal

```bash
# Remove the hook file
rm .git/hooks/commit-msg

# Remove any backups (optional)
rm -rf .git/hooks-backup
```

### Verification of Removal

```bash
# Verify hook is removed
ls -la .git/hooks/commit-msg
# Should show "No such file or directory"

# Test commit without validation
git commit -m "test commit without validation"
# Should succeed without hook validation messages
```

## Next Steps

After successful installation:

1. **Read the [Commit Standards Guide](commit-standards.md)** for detailed commit message examples
2. **Review the [Developer Guidelines](developer-guidelines.md)** for workflow integration
3. **Configure your IDE** to work with the new commit format
4. **Train your team** on conventional commit standards

## Support

For additional help:

- Check the [Developer Guidelines](developer-guidelines.md) for workflow integration
- Review [Commit Standards](commit-standards.md) for message format examples
- See [Troubleshooting Guide](troubleshooting.md) for common issues
- Open an issue in the project repository for bugs or feature requests
