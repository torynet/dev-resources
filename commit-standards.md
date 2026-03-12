# Commit Message Standards

This guide provides comprehensive examples and best practices for writing conventional commit messages that work with our automated Git hooks.

## Table of Contents

- [Conventional Commit Format](#conventional-commit-format)
- [Commit Types](#commit-types)
- [Scope Usage](#scope-usage)
- [Breaking Changes](#breaking-changes)
- [Message Examples](#message-examples)
- [Best Practices](#best-practices)
- [Common Mistakes](#common-mistakes)

## Conventional Commit Format

The basic format follows the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Format Rules

- **Type**: Must be one of the predefined types (see below)
- **Scope**: Optional, describes the section of codebase affected
- **Description**: Brief summary (max 72 characters for first line)
- **Body**: Optional detailed explanation
- **Footer**: Optional metadata (breaking changes, issue references)

## Commit Types

### Production Impact Types

These types affect versioning and releases:

#### `feat` - New Features

For new functionality that adds value to users.

```bash
feat: add user authentication system
feat(api): implement OAuth 2.0 integration
feat(ui): add dark mode toggle
```

**Version Impact**: Minor version bump (0.1.0 → 0.2.0)

#### `fix` - Bug Fixes

For fixes that resolve existing issues.

```bash
fix: resolve null pointer exception in login
fix(validation): handle empty email addresses
fix(performance): optimize database query execution
```

**Version Impact**: Patch version bump (0.1.0 → 0.1.1)

### Development Types

These types don't affect versioning but improve codebase quality:

#### `docs` - Documentation

For documentation-only changes.

```bash
docs: update API documentation
docs(readme): add installation instructions
docs: fix typos in developer guide
```

#### `style` - Code Style

For formatting, whitespace, or code style changes.

```bash
style: fix indentation in user service
style: apply prettier formatting
style(eslint): resolve linting warnings
```

#### `refactor` - Code Refactoring

For code changes that neither fix bugs nor add features.

```bash
refactor: extract user validation logic
refactor(auth): simplify token management
refactor: rename getUserData to fetchUserProfile
```

#### `test` - Tests

For adding, updating, or fixing tests.

```bash
test: add unit tests for user authentication
test(integration): add API endpoint tests
test: fix flaky authentication test
```

#### `chore` - Maintenance

For build process, dependency updates, or other maintenance.

```bash
chore: update dependencies to latest versions
chore(build): configure webpack for production
chore: add pre-commit hooks
```

### Specialized Types

#### `perf` - Performance

For performance improvements.

```bash
perf: optimize database queries
perf(cache): implement Redis caching layer
perf: reduce bundle size by 15%
```

#### `ci` - Continuous Integration

For CI/CD pipeline changes.

```bash
ci: add automated testing workflow
ci(github): update deployment pipeline
ci: fix Docker build configuration
```

#### `build` - Build System

For build tool and dependency changes.

```bash
build: update webpack configuration
build(npm): add new development dependencies
build: configure TypeScript compilation
```

#### `revert` - Reversions

For reverting previous commits.

```bash
revert: revert "feat: add user authentication"
revert(api): revert OAuth implementation due to security issue
```

## Scope Usage

Scopes provide additional context about what part of the codebase is affected.

### Common Scope Examples

#### Frontend/UI Scopes

```bash
feat(ui): add responsive navigation menu
fix(components): resolve button styling issue
style(forms): update input field appearance
```

#### Backend/API Scopes

```bash
feat(api): implement user registration endpoint
fix(database): resolve connection timeout issues
perf(queries): optimize user lookup performance
```

#### Feature-Specific Scopes

```bash
feat(auth): add password reset functionality
fix(payments): resolve subscription billing issue
test(notifications): add email delivery tests
```

#### File/Module Scopes

```bash
refactor(utils): extract common helper functions
fix(config): update environment variable handling
docs(api): document authentication endpoints
```

### Scope Guidelines

- **Be specific but not too narrow**: `feat(auth)` not `feat(auth-service-login-component)`
- **Use lowercase**: `feat(api)` not `feat(API)`
- **Keep consistent**: Establish team conventions for scope names
- **Optional but recommended**: Helps with changelog generation and filtering

## Breaking Changes

Breaking changes must be clearly indicated for proper semantic versioning.

### Method 1: Footer Syntax

```bash
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for extending other config files
```

### Method 2: Type Syntax

```bash
feat!: send an email to the customer when a product is shipped

The email includes tracking information and delivery estimates.
```

### Method 3: Scope with Breaking Change

```bash
feat(api)!: remove deprecated v1 endpoints

All v1 API endpoints have been removed. Use v2 endpoints instead.
```

**Version Impact**: Major version bump (1.0.0 → 2.0.0)

## Message Examples

### Simple Examples

```bash
# Good examples
feat: add user registration
fix: resolve login timeout issue
docs: update installation guide
test: add authentication tests
style: fix code formatting
refactor: simplify user validation
chore: update dependencies

# Bad examples
feat: stuff  # Too vague
fixed bug    # Not conventional format
Added new feature for users  # Wrong capitalization
```

### Complex Examples

#### Feature with Scope and Body

```bash
feat(auth): implement two-factor authentication

Add support for TOTP-based 2FA using authenticator apps.
Users can now enable 2FA in their security settings.

- Generate QR codes for easy setup
- Validate TOTP codes during login
- Provide backup codes for recovery
```

#### Bug Fix with Issue Reference

```bash
fix(payments): resolve subscription renewal failures

Subscription renewals were failing due to expired payment tokens.
The payment service now automatically refreshes tokens before
attempting to charge customers.

Fixes #123
```

#### Breaking Change with Migration Guide

```bash
feat(api)!: redesign user authentication endpoints

BREAKING CHANGE: Authentication endpoints have been restructured.

Before: POST /auth/login
After: POST /api/v2/auth/authenticate

Migration guide:
1. Update endpoint URLs in client applications
2. Use new request/response format (see API docs)
3. Update token refresh logic
```

#### Multi-line with Footer

```bash
refactor(database): optimize user query performance

Restructured user queries to use more efficient indexes and
reduce database load. Added connection pooling and query
result caching for frequently accessed user data.

Performance improvements:
- 40% reduction in query execution time
- 25% decrease in database CPU usage
- Better handling of concurrent user requests

Co-authored-by: Jane Developer <jane@example.com>
Reviewed-by: John Reviewer <john@example.com>
```

## Best Practices

### Writing Guidelines

1. **Use imperative mood**: "add feature" not "added feature"
2. **Lowercase first letter**: "feat: add" not "feat: Add"
3. **No period at the end**: "feat: add feature" not "feat: add feature."
4. **Be concise but descriptive**: Aim for 50-72 characters in first line
5. **Include context**: What and why, not just what

### Branch Integration

When working with GitHub issues and branches:

```bash
# Branch name: feature/123-user-authentication
git commit -m "feat: implement user login system"
# Hook automatically adds: "Issue #123"
```

### Team Consistency

1. **Establish scope conventions**: Document team-specific scopes
2. **Regular reviews**: Include commit message quality in code reviews
3. **Training**: Ensure all team members understand conventions
4. **Tools**: Use commit message templates or IDE extensions

### Helpful Patterns

#### Before and After Changes

```bash
refactor(auth): replace custom JWT with standard library

Replace our custom JWT implementation with the well-tested
jsonwebtoken library to improve security and maintainability.

Before: Custom JWT parsing with potential security issues
After: Industry-standard JWT handling with proper validation
```

#### Performance Improvements

```bash
perf(queries): implement database connection pooling

Database queries were creating new connections for each request,
causing performance bottlenecks under load.

Performance impact:
- Reduced connection overhead by 60%
- Improved response times from 500ms to 200ms
- Better resource utilization under high traffic
```

## Common Mistakes

### Format Errors

```bash
# Wrong: Missing type
"add user authentication"

# Correct:
"feat: add user authentication"

# Wrong: Wrong case
"Feat: Add user authentication"

# Correct:
"feat: add user authentication"

# Wrong: Period at end
"feat: add user authentication."

# Correct:
"feat: add user authentication"
```

### Type Selection Errors

```bash
# Wrong: Using 'feat' for bug fixes
"feat: fix login issue"

# Correct:
"fix: resolve login issue"

# Wrong: Using 'fix' for new features
"fix: add password reset feature"

# Correct:
"feat: add password reset feature"
```

### Description Issues

```bash
# Wrong: Too vague
"feat: update stuff"
"fix: fix bug"
"chore: changes"

# Correct:
"feat: add user profile management"
"fix: resolve null pointer in user service"
"chore: update Node.js dependencies"

# Wrong: Too detailed (save for body)
"feat: add user authentication system with OAuth 2.0 integration and JWT tokens and password reset functionality"

# Correct:
"feat: add user authentication system"
```

### Scope Misuse

```bash
# Wrong: Too specific
"feat(src/components/auth/LoginForm.tsx): add form validation"

# Correct:
"feat(auth): add login form validation"

# Wrong: Inconsistent naming
"feat(Authentication): add login"
"feat(auth): add logout"

# Correct: Consistent naming
"feat(auth): add login"
"feat(auth): add logout"
```

## Validation Examples

Our commit hook will validate and potentially modify your commits:

### Valid Commits (Will Pass)

```bash
✅ feat: add user registration
✅ fix(auth): resolve login timeout
✅ docs: update API documentation  
✅ test(components): add button tests
✅ feat!: remove legacy API endpoints
✅ fix(payments): resolve billing issue

BREAKING CHANGE: removed support for v1 API
```

### Invalid Commits (Will Fail)

```bash
❌ "added new feature"         # No type prefix
❌ "feat:missing space"        # Missing space after colon
❌ "Feat: wrong case"          # Wrong capitalization
❌ "unknown: invalid type"     # Unknown commit type
❌ "feat: "                    # Empty description
❌ "feat: this is way too long of a description that exceeds the recommended character limit for the first line" # Too long
```

### Auto-Injection Examples

When working on branch `feature/123-user-auth`:

```bash
# You type:
git commit -m "feat: implement OAuth integration"

# Hook automatically creates:
feat: implement OAuth integration

Issue #123
```

## IDE Integration

### VS Code Extensions

- **Conventional Commits**: Helps write proper commit messages
- **GitLens**: Enhanced Git integration with commit message templates

### JetBrains IDEs

- **Git Commit Template**: Configure commit message templates
- **Conventional Commit**: Plugin for conventional commit support

### Commit Templates

Create a commit template file:

```bash
# ~/.gitmessage
# <type>[optional scope]: <description>
# 
# [optional body]
#
# [optional footer(s)]

# Configure Git to use the template
git config --global commit.template ~/.gitmessage
```

This guide ensures your commits are properly formatted, meaningful, and work seamlessly with our automated tooling and versioning systems.
