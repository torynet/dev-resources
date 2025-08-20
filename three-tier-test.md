# Three-Tier Architecture Test Document

This document tests the new three-tier architecture with some intentional unknon words like "agentz" and "orchestrtr" to test spell checking.

## Test Scenarios

### Tier 1 (Orchestrator) Flow
1. Orchestrator calls object-model-documenter
2. object-model-documenter calls documentation-specialist for formatting
3. object-model-documenter calls spell-checking-coordinator for spelling
4. object-model-documenter returns results to orchestrator

### Expected Chain
```
Orchestrator → object-model-documenter → documentation-specialist → (terminates)
                                    → spell-checking-coordinator → (terminates)
           ← Returns recommendations
```

### Safety Verification
- Tier 3 agents cannot call anyone ✓
- Tier 2 agents can only call Tier 3 ✓  
- Maximum chain length is 3 levels ✓
- No loops possible ✓

This document contains unknown words: orchestrtr, agentz, unknon