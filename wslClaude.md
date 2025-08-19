# WSL Claude Configuration Documentation

## Overview

This Claude Code instance is running in WSL (Windows Subsystem for Linux) alongside native Windows Claude Code instances. The purpose is to enable compatibility with the Claude Autopilot VS Code extension in Cursor, which only works with Claude in WSL on Windows.

## Environment Details

- **WSL Version**: Linux 6.6.87.2-microsoft-standard-WSL2 
- **Claude Version**: 1.0.83 (Claude Code)
- **Current Working Directory**: `/mnt/d/Tory/repos/storacle`
- **User**: telar

## Configuration Symlink Setup

The WSL Claude configuration is set up to share the same configuration infrastructure as the native Windows instances through a symbolic link:

- **WSL Claude Config Path**: `/home/telar/.claude`
- **Symlink Target**: `/mnt/c/Users/telar/.claude` (Windows native config)
- **Symlink Type**: Complete directory symlink

### Shared Components

All Claude configuration components are shared between WSL and Windows instances:

1. **User Memories**: `CLAUDE.md` (global user instructions)
2. **Specialized Agents**: Complete agent library including:
   - `agent-manager.md`
   - `claude-config-manager.md` 
   - `claude-problem-solver.md`
   - `decision-documenter.md`
   - `documentation-specialist.md`
   - `instruction-compliance-checker.md`
   - `mcp-manager.md`
   - And others
3. **Settings**: `settings.json` with permissions and statusLine configuration
4. **Shell Snapshots**: Session management data
5. **Project Configurations**: Project-specific settings
6. **Downloads and IDE configurations**

### Permission Configuration

The shared `settings.json` includes comprehensive permissions for:
- File operations (Read, Edit, Write, MultiEdit)
- Git operations (status, diff, log, commit, push to origin)
- Development tools (npm, node, python, gh CLI)
- System commands (ls, cat, find, grep, rg)
- PowerShell commands (for Windows compatibility)

### Status Line Configuration

The shared status line uses PowerShell commands designed for Windows but accessible through WSL's Windows interop:
```json
"statusLine": {
  "type": "command", 
  "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ..."
}
```

## Current Working Context

- **Project**: Storacle (Salesforce development project)
- **Git Branch**: planning
- **Development Drive**: D:\ (Windows Dev Drive, accessible via `/mnt/d/`)

## Benefits of This Setup

1. **Unified Configuration**: Single source of truth for all Claude configurations
2. **Shared Agent Library**: All specialized agents available in both environments
3. **Consistent Permissions**: Same tool access across Windows and WSL
4. **Project Continuity**: Work seamlessly between environments
5. **Claude Autopilot Compatibility**: Enables Cursor extension functionality

## Key Considerations

1. **Path Translation**: Windows paths (`D:\`) vs WSL paths (`/mnt/d/`)
2. **Command Compatibility**: PowerShell commands in settings may need translation for WSL
3. **File System Permissions**: WSL inherits Windows file permissions through mount
4. **Environment Variables**: PowerShell syntax in configs vs bash/zsh in WSL

## MCP Server Compatibility

### Fixed WSL Issues

The original Windows MCP configuration used Windows-specific commands that failed in WSL:
- **Original**: `cmd /c npx @modelcontextprotocol/server-github` 
- **Fixed**: `npx @modelcontextprotocol/server-github`
- **Environment Variables**: Changed from `$env:GITHUB_TOKEN` to `${GITHUB_TOKEN}`

### Status Line Compatibility

The Windows PowerShell status line works in WSL through Windows interop:
- PowerShell commands accessible via `powershell.exe` from WSL
- No need to install PowerShell Core separately
- Single configuration works in both environments

### Current Working MCP Servers

- **GitHub**: ✅ Working - `npx @modelcontextprotocol/server-github` with `${GITHUB_TOKEN}` 
- **Notifications**: ✅ Working - `npx claude-code-notify-mcp`
- **Notion**: ✅ Working (restored by Windows Claude session)

### Environment Variable Bridge

Created `/home/telar/.wsl-env-bridge.sh` to automatically pull Windows environment variables:
- Accesses `$env:GITHUB_TOKEN` and `$env:NOTION_API_TOKEN` from Windows
- Automatically sourced in `~/.bashrc` for every WSL session
- Enables seamless environment variable sharing between Windows and WSL

## Usage Pattern

This WSL instance should operate identically to the Windows native instances, benefiting from:
- All user memories and preferences
- Complete specialized agent delegation capabilities  
- Established workflows and problem-solving patterns
- Fixed MCP server configurations working in both Windows and WSL

The symlink approach ensures that any configuration updates, new agents, or memory additions are immediately available across all Claude instances.