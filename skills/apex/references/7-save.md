# Step 7: Save

Commit and create PR.

## Load Agent

Read the agent definition: `~/.claude/agents/save.md`

Extract:
- **instructions**: The markdown content after frontmatter
- **model**: From frontmatter (opus/haiku/sonnet)

## Execute

Run save agent to:
- Stage and commit changes
- Push to remote
- Create or update PR

```javascript
Task({
  subagent_type: "save",
  model: agent.model,
  prompt: `
    ${agent.instructions}

    ---
    SAVE CONTEXT:
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
