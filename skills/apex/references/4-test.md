# Test Phase

Summarize implementation and verify with user before review.

## Task Tracking

```
TaskUpdate(taskId: "test", status: "in_progress")
```

## Process

### 1. Summarize Implementation

Collect outputs from all implement agents and present:

```markdown
## Implementation Summary

### Files Created/Modified
- `path/file.ts` - [What was done]
- `path/file.ts` - [What was done]

### Key Changes
- [Feature/component implemented]
- [Feature/component implemented]

### Implementation Decisions
- [Decision made by agents]

### Notes/Concerns
- [Any concerns flagged by agents]
```

### 2. Ask User to Verify

Use `AskUserQuestion` to check if implementation works:

```
AskUserQuestion:
  question: "Does [feature] work as expected?"
  header: "Verify"
  options:
    - label: "Yes, works correctly"
      description: "Implementation is complete and functional"
    - label: "Partially works"
      description: "Some issues need fixing"
    - label: "No, doesn't work"
      description: "Major issues, needs debugging"
```

### 3. Handle Response

**"Yes, works correctly"** → Proceed to Review phase

**"Partially works"** →
1. Ask user what's not working
2. Spawn implement agent to fix specific issue
3. Re-test with user

**"No, doesn't work"** →
1. Ask user for error details or behavior observed
2. Debug and identify root cause
3. Spawn implement agent to fix
4. Re-test with user

## Loop Until Pass

```
┌─────────────────────────────┐
│  Summarize Implementation   │
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│  AskUserQuestion: Works?    │
└──────────────┬──────────────┘
               │
    ┌──────────┼──────────┐
    ▼          ▼          ▼
   Yes      Partial       No
    │          │          │
    │          ▼          ▼
    │     Fix issue   Debug & fix
    │          │          │
    │          └────┬─────┘
    │               ▼
    │         Re-test (loop)
    ▼
Review Phase
```

## Completion

```
TaskUpdate(taskId: "test", status: "completed")
```

**Do not proceed to Review until user confirms working.**

## Skip When

- Non-functional changes (docs, config)

If skipping: `TaskUpdate(taskId: "test", status: "completed", description: "Skipped: [reason]")`
