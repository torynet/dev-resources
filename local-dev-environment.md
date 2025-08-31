# Local Development Environment Setup

## Overview

This document describes the complete setup and configuration of our Windows-based
development environment for Salesforce and web development projects.

## Core Development Tools

### PowerShell Core (PowerShell 7+)

- **Version**: 7.5.2  
- **Installation**: Download from [PowerShell GitHub releases](https://github.com/PowerShell/PowerShell/releases)
- **Purpose**: Primary cross-platform shell for all development operations
- **Location**: `C:\Program Files\PowerShell\7\pwsh.exe`

**Installation**:

**Windows**:
```powershell
winget install Microsoft.PowerShell
```

**macOS**:
```bash
brew install powershell
```

**Linux (Ubuntu/Debian)**:
```bash
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
```

**Why PowerShell Core?**:

- **Cross-platform consistency**: Identical behavior on Windows, macOS, and Linux
- **Superior MCP compatibility**: Solves MCP server issues between Windows and WSL environments
- **Better than alternatives**: More reliable than bash/cmd for cross-platform development
- **Git hook compatibility**: PowerShell scripts work seamlessly across all platforms
- **Object-oriented**: Rich object manipulation compared to text-based shells

### Git

- **Version**: 2.51.0.windows.1
- **Installation**: Download from [Git for Windows](https://git-scm.com/download/win)
- **Location**: `C:\Program Files\Git\`

**Installation**:

```powershell
winget install Git.Git
```

**Configuration**:

- Set up SSH keys for GitHub authentication
- Configure user name and email globally
- Enable LF line endings: `git config --global core.autocrlf false`

**Git Hooks Setup** (PowerShell-based for cross-platform compatibility):

```powershell
# Install PowerShell commit-msg hook for automatic issue ID prefixing
Copy-Item D:\commit-msg-hook.ps1 .git\hooks\commit-msg

# For cross-platform projects, create a wrapper script
@"
#!/bin/sh
pwsh -File `"`$(dirname `"`$0`")/commit-msg.ps1`" `"`$1`"
"@ | Out-File .git\hooks\commit-msg -Encoding utf8

# Make executable on Unix systems
if ($IsLinux -or $IsMacOS) {
    chmod +x .git/hooks/commit-msg
}
```

**Hook Features**:

- Automatically adds GitHub issue IDs to commit messages from `{prefix}/{issue-id}` branches
- Flexible: works with `dev/123`, `hotfix/456-description`, `feature/789`, etc.
- Extracts issue ID from any pattern: `{prefix}/{issue-id}` or `{prefix}/{issue-id}-{description}`
- Provides helpful warnings when not on a proper development branch
- Skips modification for merge commits, reverts, and messages already containing issue IDs
- No manual configuration needed - branch name is the single source of truth

### Node.js and npm

- **Node Version**: v24.6.0
- **npm Version**: 11.5.1
- **Installation**: Download from [Node.js official site](https://nodejs.org/)

**Installation**:

```powershell
winget install OpenJS.NodeJS
```

**Global Packages**:

```powershell
npm install -g @salesforce/cli
npm install -g markdownlint-cli
npm install -g cspell
npm install -g prettier
npm install -g prettier-plugin-apex
npm install -g @prettier/plugin-xml
```

### Python and pip

- **Python Version**: 3.13.7
- **pip Version**: 25.2
- **Installation**: Download from [Python.org](https://www.python.org/downloads/)

**Installation**:

```powershell
winget install Python.Python.3.13
```

**Global Packages**:

```powershell
pip install playwright
pip install pytest
```

## Salesforce Development

### Salesforce CLI (sf)

- **Version**: @salesforce/cli/2.79.4
- **Location**: `C:\Users\telar\AppData\Roaming\npm\sf`
- **Update Available**: 2.103.7

**Installation**:

```powershell
npm install -g @salesforce/cli
```

**Configuration**:

- Set up Dev Hub authorization
- Configure default org aliases
- Install required plugins

**Key Commands**:

```bash
sf auth web login --set-default-dev-hub --alias devhub
sf project generate --name MyProject
sf org create scratch --definition-file config/project-scratch-def.json --alias scratch
```

## GitHub Integration

### GitHub CLI (gh)

- **Version**: 2.78.0
- **Location**: `C:\Program Files\GitHub CLI\gh.exe`

**Installation**:

```powershell
winget install GitHub.cli
```

**Authentication**:

```bash
gh auth login
```

**Configuration**:

- Authenticate with GitHub account
- Set up SSH key authentication
- Configure default repository settings

## Code Editor and IDE Tools

### Cursor IDE

- **Purpose**: AI-powered code editor
- **Installation**: Download from [Cursor website](https://cursor.sh/)

**Extensions**:

- Salesforce Extension Pack
- GitLens
- Prettier
- Code Spell Checker
- PowerShell Extension

### Fork (Git Client)

- **Purpose**: Visual Git client for Windows
- **Installation**: Download from [Fork website](https://git-fork.com/)

**Configuration**:

- Connect to GitHub account
- Set up SSH key integration
- Configure merge/diff tools

## Claude Code

- **Version**: 1.0.81
- **Location**: `C:\Users\telar\.local\bin\claude.exe`

**Installation**:

```powershell
# Install via official installer from Anthropic
```

**Configuration File**: `C:\Users\telar\.claude\settings.json`

- Permissions configured for development tools
- Model set to "opusplan"
- Custom status line with PowerShell command

## Code Quality Tools

### Prettier

- **Purpose**: Code formatting
- **Installation**:

```powershell
npm install -g prettier
```

**Configuration**: Create `.prettierrc` in project root:

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "plugins": [
    "prettier-plugin-apex",
    "@prettier/plugin-xml"
  ],
  "overrides": [
    {
      "files": "*.{cls,trigger}",
      "options": {
        "parser": "apex"
      }
    },
    {
      "files": "*.md",
      "options": {
        "proseWrap": "preserve",
        "printWidth": 80
      }
    }
  ]
}
```

### CSpell (Code Spell Checker)

- **Purpose**: Spell checking for code and documentation
- **Installation**:

```powershell
npm install -g cspell
```

**Configuration Files**:

- Global: `C:\Users\telar\.claude\cspell.json`
- Project: `D:\Tory\repos\storacle\cspell.json`
- VSCode: `D:\Tory\repos\storacle\.vscode\cspell.json`

**Project Configuration** (`cspell.json`):

```json
{
  "version": "0.2",
  "language": "en",
  "import": ["C:\\Users\\telar\\.claude\\cspell.json"],
  "words": [
    "CCPM",
    "DEVHUB",
    "Storacle",
    "sfdx"
  ],
  "ignorePaths": [
    "node_modules/**",
    ".git/**",
    ".history/**"
  ]
}
```

### Playwright

- **Purpose**: End-to-end testing framework
- **Installation**:

```powershell
pip install playwright
playwright install
```

**Configuration**:

```powershell
# Initialize Playwright in project
npx playwright install
```

## Environment Variables

### Key Environment Variables

#### Development Environment
- `DEV`: Points to development drive (`D:`) for cross-platform compatibility
- `HOME`: User home directory (Windows: `%USERPROFILE%`, Unix: `$HOME`)
- `CLAUDE_CONFIG_PATH`: Path to Claude configuration directory (`$HOME\.claude`)

#### Cross-Platform Compatibility
- `SHELL`: Set to `pwsh` for consistent PowerShell behavior
- `TERM`: Set to `xterm-256color` for proper terminal color support

#### Salesforce Development
- `SFDX_DISABLE_AUTOUPDATE`: Set to `true` to prevent automatic CLI updates
- `DEVHUB_USERNAME`: Default Dev Hub username for Salesforce projects

#### Node.js Development
- `NODE_ENV`: Set to `development` for local development

### PowerShell Profile Setup

Add to PowerShell profile (`$PROFILE`):

```powershell
# Development environment shortcuts
Set-Alias -Name sf -Value "C:\Users\telar\AppData\Roaming\npm\sf.cmd"
Set-Alias -Name gh -Value "C:\Program Files\GitHub CLI\gh.exe"

# Cross-platform environment variables
$env:DEV = "D:"
$env:HOME = $env:USERPROFILE
$env:CLAUDE_CONFIG_PATH = "$env:HOME\.claude"

# Development environment variables
$env:SFDX_DISABLE_AUTOUPDATE = "true"
$env:NODE_ENV = "development"
$env:DEVHUB_USERNAME = "your-devhub@example.com"

# Cross-platform compatibility
$env:SHELL = "pwsh"
$env:TERM = "xterm-256color"
```

## Project Structure Standards

### Directory Layout

```text
${DEV}/
├── repos/
│   └── project-name/
│       ├── .vscode/
│       │   └── cspell.json
│       ├── cspell.json
│       ├── CLAUDE.md
│       └── README.md
├── claude-agent.log
└── local-dev-environment.md
```

### File Conventions

- Use LF line endings for all files
- Use UTF-8 encoding
- Follow project-specific naming conventions
- Include comprehensive spell check dictionaries

## Initialization Checklist

### Initial Environment Setup

1. **Clone User Configuration**:

   ```bash
   # Clone Claude configuration from GitHub
   cd C:\Users\telar
   git clone https://github.com/username/claude-config.git .claude
   ```

2. **Clone Development Environment**:

   ```bash
   # Clone development drive setup and tools
   git clone https://github.com/username/dev-environment.git D:\dev-setup
   # Copy or link development environment files to D:\
   ```

3. **Configure Cross-Platform Environment Variables**:

   ```powershell
   # Ensure PowerShell profile exists
   if (!(Test-Path $PROFILE)) {
       New-Item -Path $PROFILE -ItemType File -Force
   }
   
   # Add environment variables for cross-platform compatibility
   Add-Content $PROFILE @"
   # Cross-platform development environment
   `$env:DEV = 'D:'
   `$env:HOME = `$env:USERPROFILE
   `$env:CLAUDE_CONFIG_PATH = '`$env:HOME\.claude'
   `$env:SHELL = 'pwsh'
   `$env:TERM = 'xterm-256color'
   "@
   ```

### New Project Setup

1. **Create Repository**:

   ```bash
   gh repo create project-name --private
   git clone https://github.com/username/project-name.git
   cd project-name
   ```

2. **Salesforce Project**:

   ```bash
   sf project generate --name project-name
   sf org create scratch --definition-file config/project-scratch-def.json
   ```

3. **Configuration Files**:
   - Create `cspell.json`
   - Create `CLAUDE.md` project instructions
   - Set up `.vscode/cspell.json`
   - Configure `.prettierrc`

4. **Quality Tools**:

   ```bash
   npx cspell "**/*.{js,ts,md,json}"
   npx prettier --write "**/*.{js,ts,json,md}"
   npx markdownlint "**/*.md"
   ```

### Branch Naming and Issue Tracking

**Flexible Branch Pattern**: `{prefix}/{issue-id}` or `{prefix}/{issue-id}-{description}`

```bash
# Standard development branches
git checkout -b dev/123
git checkout -b dev/456-fix-validation

# Hotfixes
git checkout -b hotfix/789
git checkout -b hotfix/101-security-patch

# Features  
git checkout -b feature/202
git checkout -b feature/303-user-dashboard

# Bug fixes
git checkout -b bugfix/404-memory-leak
```

**Automatic Issue ID Integration**:

The commit-msg hook automatically extracts the issue ID from any `{prefix}/{issue-id}` pattern:

```bash
# On branch dev/123
git commit -m "Fix validation logic"
# Automatically becomes: "#123: Fix validation logic"

# On branch hotfix/456-security  
git commit -m "Patch XSS vulnerability"
# Automatically becomes: "#456: Patch XSS vulnerability"

# On branch feature/789-dashboard
git commit -m "Add user metrics component"
# Automatically becomes: "#789: Add user metrics component"
```

**Hook Behavior Examples**:

- ✅ `dev/123` → `"Add endpoint"` → `"#123: Add endpoint"`
- ✅ `hotfix/456` → `"Fix bug"` → `"#456: Fix bug"`
- ✅ `feature/789-dashboard` → `"Add UI"` → `"#789: Add UI"`
- ℹ️ `main` → `"Update docs"` → `"Update docs"` (no change)
- ⚠️ `random-branch` → Warning: use `{prefix}/{issue-id}` pattern
- ❌ Already prefixed → `"#123: Fix"` → `"#123: Fix"` (no change)

### Development Workflow

1. **Start Claude Code**:

   ```bash
   claude
   ```

2. **Check Project Health**:

   ```bash
   git status
   sf org list
   npm list
   ```

3. **Run Quality Checks**:

   ```bash
   cspell "**/*.md"
   prettier --check "**/*.js"
   ```

## Troubleshooting

### Common Issues

#### Salesforce CLI Update Warnings

- Run `sf update` to update to latest version
- Set `SFDX_DISABLE_AUTOUPDATE=true` to suppress warnings

#### PowerShell Execution Policy

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Node.js Permission Issues

```powershell
npm config set prefix ~/.npm-global
# Add ~/.npm-global/bin to PATH
```

#### Git SSH Authentication

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
gh auth refresh -h github.com -s admin:public_key
```

## Tool Versions Reference

| Tool | Current Version | Latest Available | Update Command |
|------|----------------|------------------|----------------|
| PowerShell | 7.5.2 | - | `winget upgrade Microsoft.PowerShell` |
| Git | 2.51.0 | - | `winget upgrade Git.Git` |
| Node.js | 24.6.0 | - | `winget upgrade OpenJS.NodeJS` |
| npm | 11.5.1 | - | `npm install -g npm@latest` |
| Python | 3.13.7 | - | `winget upgrade Python.Python.3.13` |
| pip | 25.2 | - | `python -m pip install --upgrade pip` |
| Salesforce CLI | 2.79.4 | 2.103.7 | `sf update` |
| GitHub CLI | 2.78.0 | - | `winget upgrade GitHub.cli` |
| Claude Code | 1.0.81 | - | Update via official installer |

## Additional Resources

### Documentation Links

- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs)

### Configuration Templates

- [Salesforce Project Template](https://github.com/forcedotcom/salesforcedx-templates)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Prettier Configuration](https://prettier.io/docs/en/configuration.html)
