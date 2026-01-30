# Test Phase

Verify the implementation works before formal review.

## User Validation

Use `AskUserQuestion` to confirm the feature works:

```
Question: "Does the [feature] work as expected?"
Options:
- "Yes, works correctly" → Proceed to Review
- "Partially works" → Ask what's broken, fix, re-test
- "No, doesn't work" → Debug and fix issues
```

## Testing Approaches

### 1. Manual Testing (Default)
Ask the user to test the feature manually:
- Provide clear steps to test
- Specify expected behavior
- Ask for confirmation

### 2. Automated Testing
If the codebase has tests, use the `test` subagent:
```
Task (subagent_type: test):
- Run existing test suite
- Verify no regressions
- Check new functionality
```

### 3. Browser Testing
For frontend changes, use `agent-browser` skill:
- Navigate to the feature
- Interact with UI elements
- Capture screenshots for verification

## Iteration

If testing reveals issues:
1. Identify the root cause
2. Fix the specific issue
3. Re-test only the affected functionality
4. Confirm fix with user

Do not proceed to Review until testing passes.
