# WSL Setup Documentation for Claude Code

This document tracks all configurations made to enable Claude Code to work seamlessly across both Windows (PowerShell) and WSL environments.

## WSL Installation and Basic Configuration

### Initial Setup
- WSL2 installed on Windows
- Ubuntu distribution (version can be checked with `lsb_release -a`)
- Symlinks created to share configurations between Windows and WSL:
  - `/home/telar/.claude` → `/mnt/c/Users/telar/.claude` (shared Claude configuration)
  - This ensures both environments use the same agents, memories, and settings

## Python Configuration

### Python Alias Setup
WSL comes with Python 3 but not `python` command by default:
- Created symlink: `ln -sf /usr/bin/python3 ~/.local/bin/python`
- This makes `python` command available (resolves to Python 3.12.3)

### Pip Installation
- Installed pip using the official installer:
  ```bash
  curl -sS https://bootstrap.pypa.io/get-pip.py | python - --user --break-system-packages
  ```
- The `--break-system-packages` flag was required due to Ubuntu's externally-managed Python environment

### MCP Package Installation
- Installed MCP package for Python-based MCP servers:
  ```bash
  python -m pip install --user --break-system-packages mcp
  ```

## Environment Variables

### Cross-Platform Variables
Set up environment variables that resolve differently in each environment:

#### DEV Variable (Development Drive)
- **Windows**: `DEV=D:\`
- **WSL**: `DEV=/mnt/d/`
- Added to `~/.bashrc`: `export DEV="/mnt/d/"`

#### MCP_LOG_SERVER_PATH Variable
- **Windows**: `MCP_LOG_SERVER_PATH=C:\Users\telar\mcp-servers\log-server\log_server.py`
- **WSL**: `MCP_LOG_SERVER_PATH=/mnt/c/Users/telar/mcp-servers/log-server/log_server.py`
- Added to `~/.bashrc`: `export MCP_LOG_SERVER_PATH="/mnt/c/Users/telar/mcp-servers/log-server/log_server.py"`

#### GITHUB_TOKEN
- Environment variable shared between both environments for GitHub MCP server authentication

## Claude Configuration Paths

### The Six-Path Strategy
Due to path format differences between Windows and WSL, some Claude configurations reference paths that exist in one environment but not the other. This results in startup warnings but doesn't break functionality:

#### Windows-Specific Paths (work in Windows, error in WSL):
1. `D:\` - Windows drive reference
2. `C:\Users\telar\.claude` - Windows user Claude directory  
3. `C:\Users\telar` - Windows user directory

#### WSL-Specific Paths (work in WSL, error in Windows):
1. `/mnt/d/` - WSL mount point for D: drive
2. `/home/telar/.claude` - WSL user Claude directory
3. `/home/telar` - WSL user directory

These path errors are cosmetic - each environment successfully finds its valid paths while ignoring the invalid ones.

## MCP Server Configuration

### Command Execution Challenges
- **Windows Issue**: Direct `npx` commands fail when executed by Claude Code
  - Windows needs `cmd /c npx` wrapper to properly execute npx.cmd batch files
  - This is because Node.js child_process doesn't handle .cmd files without a shell

- **WSL Issue**: `cmd` command doesn't exist
  - WSL has access to `cmd.exe` via `/mnt/c/Windows/system32/cmd.exe`
  - But the configuration uses `cmd` which isn't found

### Final MCP Configuration (Cross-Platform)
```json
{
  "mcpServers": {
    "github": {
      "command": "pwsh",
      "args": ["-Command", "npx @modelcontextprotocol/server-github"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    },
    "notifications": {
      "command": "pwsh",
      "args": ["-Command", "npx claude-code-notify-mcp"]
    },
    "log-server": {
      "command": "python",
      "args": ["${MCP_LOG_SERVER_PATH}"],
      "env": {"DEV": "${DEV}"}
    }
  }
}
```

### All Solutions Working
- **github & notifications**: Now work in both environments using `pwsh -Command`
- **log-server**: Works in both environments due to:
  - Python symlink in WSL (`python` → `python3`)
  - Environment variable for path (`${MCP_LOG_SERVER_PATH}`)
  - MCP package installed in WSL

## NPM/Node.js Access
- WSL has access to Windows Node.js installation: `/mnt/c/Program Files/nodejs/`
- Commands like `npx` are available but are actually Windows executables

## PowerShell Core Setup (Completed)

### Solution: Symlink to Windows PowerShell 7
Instead of installing PowerShell Core separately, we created a symlink to the existing Windows PowerShell 7 installation:

```bash
mkdir -p ~/.local/bin
ln -sf "/mnt/c/Program Files/PowerShell/7/pwsh.exe" ~/.local/bin/pwsh
```

This provides:
- **Cross-platform `pwsh` command**: Works identically in both Windows and WSL
- **Same PowerShell version**: Uses PowerShell 7.5.2 in both environments  
- **No sudo required**: Uses existing Windows installation
- **Consistent behavior**: Identical PowerShell environment across platforms

### Benefits Achieved
- Can use `pwsh -Command` consistently across both platforms
- Eliminates need for `cmd.exe` wrapper for MCP servers
- Provides consistent PowerShell cmdlet environment
- Simplifies status line configuration potential

## Status Line Configuration
Currently uses PowerShell-specific command that only works in Windows:
```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"...\""
  }
}
```

With PowerShell Core, this could potentially become cross-platform using `pwsh` instead of `powershell.exe`.

## Outstanding Issues

1. ~~**MCP Servers**: GitHub and notifications servers fail in WSL due to `cmd` not being found~~ ✅ **SOLVED**
2. **Status Line**: Doesn't work in WSL due to PowerShell dependency (could potentially be solved with `pwsh`)
3. **Path Warnings**: Startup warnings about invalid paths (cosmetic issue)

## Final Status

### ✅ Working Cross-Platform
- **All MCP Servers**: github, notifications, and log-server now work identically in both Windows and WSL
- **Python Environment**: Consistent `python` command and MCP package availability
- **Environment Variables**: Cross-platform path resolution for `$DEV` and `$MCP_LOG_SERVER_PATH`
- **PowerShell Access**: `pwsh` command available in both environments using same PowerShell 7.5.2 installation

### 🔧 Potential Improvements
- **Status Line**: Could potentially use `pwsh` for cross-platform status line functionality
- **Path Warnings**: Could be eliminated with more sophisticated path handling, but doesn't affect functionality

### 📋 Summary
The WSL setup now provides a fully functional Claude Code environment that shares configuration with Windows while working around platform differences through:
- Symlinks for shared configuration
- Environment variables for cross-platform paths  
- PowerShell 7 for consistent command execution
- Platform-specific executable resolution (python/python3)