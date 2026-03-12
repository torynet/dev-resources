# Developer Guidelines for Commit Hooks

This guide helps developers integrate the commit hook system into their daily workflow and understand how it enhances the development process.

## Table of Contents

- [Quick Start](#quick-start)
- [Development Workflow Integration](#development-workflow-integration)
- [IDE Configuration](#ide-configuration)
- [Team Collaboration](#team-collaboration)
- [Troubleshooting Workflow Issues](#troubleshooting-workflow-issues)
- [Advanced Usage](#advanced-usage)

## Quick Start

### New Developer Onboarding

1. **Clone the repository**:

   ```bash
   git clone https://github.com/your-org/your-project.git
   cd your-project
   ```

2. **Install commit hooks**:

   ```bash
   # Linux/macOS
   ./scripts/install-salesforce-hooks.sh
   
   # Windows PowerShell
   .\scripts\install-hooks.ps1
   ```

3. **Verify installation**:

   ```bash
   git commit -m "test: verify hook installation" --dry-run
   ```

4. **Read the standards**:
   - Review [Commit Standards](commit-standards.md)
   - Check [Installation Guide](commit-hooks-installation.md)

### First Commit Test

```bash
# Create a test branch
git checkout -b feature/999-test-hooks

# Make a small change
echo "# Test" > test.md
git add test.md

# Test the hook with a valid commit
git commit -m "feat: add test documentation"

# Verify the commit includes issue reference
git log --oneline -1
# Should show: feat: add test documentation (Issue #999)

# Clean up
git checkout main
git branch -D feature/999-test-hooks
```

## Development Workflow Integration

### Branch Naming Convention

To take advantage of automatic issue injection, use these branch naming patterns:

```bash
# Feature branches
feature/123-user-authentication
feature/456-payment-integration

# Bug fix branches  
fix/789-login-timeout
bugfix/101-validation-error

# Documentation branches
docs/234-api-documentation
documentation/567-readme-update

# Hotfix branches
hotfix/890-critical-security-patch
```

### Standard Development Cycle

#### 1. Start New Feature

```bash
# Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/123-user-profile-management

# Work on your feature
# ... make changes ...

# First commit
git add .
git commit -m "feat: implement user profile data model"
# Hook adds: "Issue #123"
```

#### 2. Incremental Development

```bash
# Additional commits as you work
git commit -m "feat: add profile validation logic"
git commit -m "test: add unit tests for profile service" 
git commit -m "docs: add profile API documentation"
git commit -m "fix: resolve validation edge case"

# Each commit automatically includes "Issue #123"
```

#### 3. Code Review Preparation

```bash
# Review your commit history
git log --oneline

# Ensure all commits follow conventions
git log --grep="^(feat|fix|docs|test|chore|style|refactor|perf|ci|build|revert)"

# Push feature branch
git push origin feature/123-user-profile-management
```

#### 4. Pull Request

Create PR with confidence knowing:

- All commits follow conventional format
- Issue references are automatically included
- Semantic versioning will work correctly
- Changelog generation will include your changes

### Handling Different Development Scenarios

#### Bug Fixes

```bash
# Emergency bug fix
git checkout -b hotfix/urgent-security-patch

# Quick fix commit
git commit -m "fix: patch SQL injection vulnerability"
# For urgent fixes, use --no-verify if needed:
# git commit --no-verify -m "EMERGENCY: critical security patch"
```

#### Documentation Updates

```bash
# Documentation branch
git checkout -b docs/456-api-reference

# Documentation commits
git commit -m "docs: update authentication API examples"
git commit -m "docs: add troubleshooting section"
git commit -m "docs: fix broken links in README"
```

#### Refactoring Work

```bash
# Refactoring branch
git checkout -b refactor/789-user-service-cleanup

# Refactoring commits
git commit -m "refactor: extract user validation logic"
git commit -m "refactor: simplify user data transformation"
git commit -m "test: update tests for refactored user service"
```

#### Breaking Changes

```bash
# Feature with breaking changes
git checkout -b feature/breaking-api-redesign

# Breaking change commit (method 1 - footer)
git commit -m "feat: redesign user API endpoints

BREAKING CHANGE: User API endpoints have changed from /users to /api/v2/users"

# Breaking change commit (method 2 - ! syntax)  
git commit -m "feat!: remove deprecated authentication methods"
```

## IDE Configuration

### Visual Studio Code

#### Recommended Extensions

1. **Conventional Commits**: Auto-complete for commit types
2. **GitLens**: Enhanced Git integration
3. **Git History**: Visual commit history
4. **Git Blame**: Inline blame annotations

#### Settings Configuration

Add to `.vscode/settings.json`:

```json
{
  "git.inputValidation": true,
  "git.inputValidationLength": 72,
  "git.inputValidationSubjectLength": 50,
  "conventionalCommits.showEditor": true,
  "conventionalCommits.lineBreak": "\\n"
}
```

#### Commit Message Template

Create `.vscode/commit-template.txt`:

```
# <type>[optional scope]: <description>
# 
# [optional body]
#
# [optional footer(s)]
#
# Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert
# Remember: Use imperative mood, lowercase, no period at end
```

Configure in settings:

```json
{
  "git.commitMessageTemplate": ".vscode/commit-template.txt"
}
```

### JetBrains IDEs (IntelliJ, WebStorm, etc.)

#### Plugin Installation

1. Install "Conventional Commit" plugin
2. Install "GitToolBox" for enhanced Git features

#### Configuration

1. **File → Settings → Version Control → Git**
2. **Commit Message Template**:

   ```
   <type>[optional scope]: <description>
   
   [optional body]
   
   [optional footer(s)]
   ```

3. **Enable commit message validation**
4. **Set up live templates** for common commit types

### Other IDEs

#### Sublime Text

- Install "GitSavvy" package
- Configure commit message template

#### Vim/Neovim

- Use "vim-fugitive" plugin
- Configure commit message template in `.gitmessage`

#### Eclipse

- Use EGit plugin
- Configure commit message template

## Team Collaboration

### Code Review Guidelines

#### Reviewing Commits

When reviewing PRs, check:

```bash
# Good commit history example
✅ feat: implement user authentication
✅ test: add authentication unit tests  
✅ docs: update API documentation
✅ fix: resolve edge case in validation

# Poor commit history example  
❌ WIP: working on stuff
❌ fix typo
❌ more changes
❌ final version
```

#### Commit Message Quality

Look for:

- **Clear intent**: Each commit should have a single, clear purpose
- **Proper format**: Follows conventional commit standards
- **Logical grouping**: Related changes are in the same commit
- **Atomic commits**: Each commit should be independently deployable

### Branch Strategy Integration

#### Git Flow with Hooks

```bash
# Feature development
git flow feature start 123-new-feature
# Work and commit with conventional messages
git flow feature finish 123-new-feature

# Release preparation
git flow release start 1.2.0
# Only allow fix, docs, and chore commits
git flow release finish 1.2.0

# Hotfix workflow
git flow hotfix start 1.1.1
# Use fix: commits for patches
git flow hotfix finish 1.1.1
```

#### GitHub Flow with Hooks

```bash
# Create feature branch
git checkout -b feature/123-new-feature

# Development with conventional commits
git commit -m "feat: implement core functionality"
git commit -m "test: add comprehensive test suite"
git commit -m "docs: update feature documentation"

# Pull request review
# Commits are already properly formatted
# Automatic changelog generation works
# Semantic versioning is accurate
```

### Team Standards

#### Commit Message Reviews

Include commit quality in your definition of done:

- [ ] All commits follow conventional format
- [ ] Commit messages are clear and descriptive
- [ ] No "WIP" or "fix typo" commits in main branch
- [ ] Breaking changes are properly marked
- [ ] Issue references are included

#### Training Checklist

New team members should:

- [ ] Install commit hooks successfully
- [ ] Complete test commit cycle
- [ ] Review commit standards documentation
- [ ] Practice different commit types
- [ ] Understand breaking change syntax
- [ ] Configure their IDE for conventional commits

## Troubleshooting Workflow Issues

### Hook Interference with Workflow

#### Issue: Hook Slows Down Commits

```bash
# Check hook execution time
time git commit -m "feat: test performance"

# If slow, check for network dependencies
# Temporarily disable network checks if needed
```

#### Issue: Hook Conflicts with Git GUI Tools

```bash
# Test with command line first
git commit -m "feat: test GUI compatibility"

# For SourceTree, GitHub Desktop, etc.
# Ensure hooks work from IDE terminal
```

#### Issue: Merge Conflicts with Hook Messages

```bash
# During merge, hook might modify commit messages
# Check final commit message after merge
git log --oneline -5
```

### Emergency Procedures

#### Bypass Hook Temporarily

```bash
# Method 1: Use EMERGENCY prefix
git commit -m "EMERGENCY: critical production fix"

# Method 2: Use --no-verify flag
git commit --no-verify -m "urgent fix needed now"

# Method 3: Temporarily disable hook
mv .git/hooks/commit-msg .git/hooks/commit-msg.backup
git commit -m "emergency commit"
mv .git/hooks/commit-msg.backup .git/hooks/commit-msg
```

#### Restore Normal Operation

```bash
# Verify hook is working
git commit -m "test: verify hook restoration" --dry-run

# Fix any issues found
./scripts/install-salesforce-hooks.sh --force
```

### Performance Optimization

#### Large Repository Considerations

```bash
# For repositories with thousands of commits
# Ensure hook doesn't scan entire history
# Current hook only processes current commit

# Monitor hook performance
time .git/hooks/commit-msg test-message.txt
```

#### Network Dependency Issues

```bash
# If GitHub CLI is slow or unavailable
# Hook should gracefully degrade
# Test offline behavior
```

## Advanced Usage

### Custom Hook Configuration

#### Environment Variables

```bash
# Skip issue injection
export SKIP_ISSUE_INJECTION=true
git commit -m "feat: commit without issue reference"

# Skip validation (use with caution)
export SKIP_COMMIT_VALIDATION=true
git commit -m "any message format"
```

#### Project-Specific Customization

Create `.git/hooks/commit-msg.local`:

```bash
#!/bin/bash
# Project-specific hook customizations

# Add custom validation logic
# Add project-specific issue patterns
# Add custom scope validation
```

### Integration with CI/CD

#### Validation in CI Pipeline

```yaml
# .github/workflows/validate-commits.yml
name: Validate Commits
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Validate commit messages
        run: |
          # Validate all commits in PR
          git log --format="%s" ${{ github.event.before }}..${{ github.sha }} | \
          while read commit_msg; do
            if [[ ! "$commit_msg" =~ ^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.*\))?!?: ]]; then
              echo "Invalid commit message: $commit_msg"
              exit 1
            fi
          done
```

#### Automated Changelog Generation

```bash
# Use conventional-changelog tools
npm install -g conventional-changelog-cli

# Generate changelog from conventional commits
conventional-changelog -p angular -i CHANGELOG.md -s
```

#### Semantic Versioning Automation

```bash
# Use semantic-release for automated versioning
npm install -g semantic-release

# Configure in package.json or .releaserc
{
  "release": {
    "branches": ["main"],
    "plugins": [
      "@semantic-release/commit-analyzer",
      "@semantic-release/release-notes-generator",
      "@semantic-release/changelog",
      "@semantic-release/github"
    ]
  }
}
```

### Hook Development and Testing

#### Testing Hook Changes

```bash
# Test hook with various commit messages
echo "feat: test message" | .git/hooks/commit-msg /dev/stdin
echo "invalid message" | .git/hooks/commit-msg /dev/stdin

# Test issue injection
BRANCH_NAME="feature/123-test" .git/hooks/commit-msg test-commit.txt
```

#### Contributing Hook Improvements

```bash
# Create development branch
git checkout -b feature/hook-improvements

# Modify hook scripts
# Add tests for new functionality
# Update documentation

# Test thoroughly before submitting PR
```

This guide ensures developers can effectively use the commit hook system while maintaining productivity and code quality standards.
