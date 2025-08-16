# Claude Problems and Solutions

This file tracks errors, failures, and issues encountered by Claude or its agents, along with analysis, solutions, and prevention strategies.

## Problem Documentation Format

Each problem entry should follow this structure:

```markdown
## Problem: [Short Description]
**Date**: [ISO Date]
**Context**: [What was being attempted]
**Error**: [Exact error message/failure]
**Root Cause**: [Analysis of why it happened]
**Solution**: [How to fix it]
**Prevention**: [How to avoid it in future]
**Status**: Unresolved
---
```

## Outstanding Issues

## Problem: Edit Tool String Matching Failures on Agent Files
**Date**: 2025-08-16
**Context**: Attempting to update agent-manager.md with new tools inventory maintenance section using Edit tool with exact string replacement
**Error**: "String to replace not found in file" - Edit operation failed when trying to replace multi-line content in agent files that had been recently modified
**Root Cause**: 
- Exact string matching brittleness in Edit tool when content has slight formatting differences
- Files modified by other agents/processes between read and edit operations
- Potential whitespace/line ending inconsistencies not visible in standard file reads
- Multi-line string replacements more prone to exact matching failures
**Solution**: 
- Always re-read files immediately before editing if other processes may have modified them
- Use smaller, more specific string replacements rather than large multi-line blocks
- Consider using MultiEdit for multiple smaller changes instead of single large replacements
- Verify exact formatting including invisible characters when debugging edit failures
**Prevention**: 
- Implement pre-edit file staleness checks
- Use more granular edit strategies (single lines or small blocks)
- Create agent coordination mechanisms to prevent concurrent file modifications
- Develop fallback strategies using Write tool when Edit fails repeatedly
**Status**: Unresolved

## Problem: Mid-Session Instruction Updates Not Automatically Applied
**Date**: 2025-08-16
**Context**: Error handling instructions were updated during session, but primary Claude continued using old patterns instead of delegating errors to claude-problem-solver agent
**Error**: Primary Claude executed error analysis directly instead of following updated delegation instructions for error handling
**Root Cause**: 
- Instruction updates in CLAUDE.md files are not automatically reloaded during active sessions
- No mechanism to notify active Claude instances of instruction changes
- User must manually reference updated instructions or restart session
**Solution**: 
- Implement explicit instruction reload mechanisms when instructions change
- Create notification patterns for instruction updates during sessions
- Establish session checkpointing that includes instruction refresh
**Prevention**: 
- Design instruction update workflows that include active session notification
- Create versioned instruction systems that can detect changes
- Implement periodic instruction refresh in long-running sessions
- Establish clear patterns for when to restart vs. continue sessions after instruction changes
**Status**: Unresolved

---

## Resolved Issues

*No resolved problems currently documented.*