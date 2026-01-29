# Step 3: Implement

Execute the plan.

## Execute

Run `implement` agents for each subtask:
- Independent subtasks (no shared files): parallel Task calls in a single message
- Dependent subtasks: sequential execution

```javascript
// Parallel execution for independent subtasks
Task({ subagent_type: "implement", prompt: "Subtask 1: ...", run_in_background: true })
Task({ subagent_type: "implement", prompt: "Subtask 2: ...", run_in_background: true })

// Sequential execution for dependent subtasks
Task({ subagent_type: "implement", prompt: "Subtask 3: ..." })
```

## Rules

1. **File Conflicts**: Never assign the same file to parallel agents
2. **Dependencies**: Execute dependent subtasks sequentially

## Show Progress

Display completion status as subtasks finish.

## Next

- `-st` flag: skip to `~/.claude/skills/apex/references/5-review.md`
- Otherwise: read `~/.claude/skills/apex/references/4-test.md`
