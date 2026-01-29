# Step 4: Test

Verify implementation works.

## Execute

Run `test` agent with mode based on flags:
- `-at`: automated testing
- Default: manual user verification

```javascript
Task({
  subagent_type: "test",
  prompt: `
    Test the implementation. Mode: ${flags.at ? 'automated' : 'manual'}

    Changes made:
    - <list of implemented subtasks>

    Test scenarios to verify:
    - <generated from subtask descriptions>
  `
})
```

## Handle Failures

If tests fail:
1. Document failing scenarios
2. Return to implement phase or continue with warning

## Next

Read: `~/.claude/skills/apex/references/5-review.md`
