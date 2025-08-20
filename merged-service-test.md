# Merged Document Service Test

This document tests the new merged documentation-specialist service that
combines formatting and spell checking.

## Test Content

Here are some intentional issues to test:

### Formatting Issues

- Missing spaces around headers
- Improper list formatting
  - Inconsistent indentation
- trailing spaces at end of lines

### Spelling Issues

- Unknown project terms: Storacle, orchestrator
- Universal coding terms: refactoring, polymorphism
- Random IDs: abc123xyz789
- Obvious misspellings: receive, separate

## Expected Results

The merged service should:

1. Fix all formatting issues automatically
2. Categorize and add appropriate words to dictionaries
3. Return only truly uncertain words requiring decisions
4. Provide comprehensive document quality results

Testing the merged documentation-specialist service.
