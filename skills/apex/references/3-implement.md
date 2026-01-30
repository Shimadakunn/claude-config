# Step 3: Implement

Execute the plan.

## Load Agent

Read the agent definition: `~/.claude/agents/implement.md`

Extract:
- **instructions**: The markdown content after frontmatter
- **model**: From frontmatter (opus/haiku/sonnet)

## Execute

Run implement agents for each subtask:
- Independent subtasks (no shared files): parallel Task calls in a single message
- Dependent subtasks: sequential execution

```javascript
// Parallel execution for independent subtasks
Task({
  subagent_type: "implement",
  model: agent.model,
  prompt: `${agent.instructions}\n\n---\nSUBTASK:\n${subtask_1}`,
  run_in_background: true
})
Task({
  subagent_type: "implement",
  model: agent.model,
  prompt: `${agent.instructions}\n\n---\nSUBTASK:\n${subtask_2}`,
  run_in_background: true
})

// Sequential execution for dependent subtasks
Task({
  subagent_type: "implement",
  model: agent.model,
  prompt: `${agent.instructions}\n\n---\nSUBTASK:\n${subtask_3}`
})
```

## Rules

1. **File Conflicts**: Never assign the same file to parallel agents
2. **Dependencies**: Execute dependent subtasks sequentially

## Show Progress

Display completion status as subtasks finish.

## Next

- `-st` flag: skip to `~/.claude/skills/apex/references/5-review.md`
- Otherwise: read `~/.claude/skills/apex/references/4-test.md`
