# Step 7: Save

Commit and create PR.

## Execute

Run `save` agent to:
- Stage and commit changes
- Push to remote
- Create or update PR

```javascript
Task({
  subagent_type: "save",
  prompt: `
    Save the implementation.

    Summary of changes:
    - <list of completed subtasks>

    Context for commit message:
    - <original task description>
  `
})
```

## Complete

Display final summary:
- Completed subtasks
- Review findings addressed
- Commit SHA
- PR URL (if created)
