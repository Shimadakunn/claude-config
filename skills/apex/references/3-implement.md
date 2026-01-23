# Step 3: Implement

**Purpose:** Execute the implementation by spawning implement agents for each task.

---

## Get Tasks to Implement

**If `-sp` flag was used (no planning):**
- Create a single task from `workflow_state.task` and `workflow_state.exploration_output`

**Otherwise:**
- Use `workflow_state.plan.tasks`

---

## Execute Implementation

For each task (respecting dependencies), use the **Task tool** to spawn the implement agent:

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Implement: {task.description}"
  prompt: |
    You are the implement agent.
    Read and follow: ~/.claude/agents/implement.md

    TASK:
    - Description: {task.description}
    - Files: {task.files.join(", ")}
    - Requirements: {task.requirements.join(", ")}
    - Edge cases: {task.edge_cases.join(", ")}
    - Security notes: {task.security_notes.join(", ")}
    - Acceptance criteria: {task.acceptance_criteria.join(", ")}

    EXPLORATION CONTEXT:
    {workflow_state.exploration_output.merged_insights}

    Implement this task following the quality criteria in the agent instructions.
    Return structured output with changes made, edge cases handled, and acceptance criteria verification.
```

### Execution Order:

1. Group tasks by dependency level
2. Tasks with no dependencies → run in parallel
3. Tasks with dependencies → wait for dependencies, then run
4. Collect outputs from each task

---

## Store in Workflow State

```
workflow_state.implementation_output = {
  tasks_completed: [...],
  files_modified: [...],
  summary: "..."
}
```

## Display Summary

```
Step 3: Implement - Complete
============================

Tasks completed: {tasks_completed.length}

Changes:
{for each task in tasks_completed:}
  [{task.id}] {task.description}
      Files: {task.files_modified.join(", ")}
      Status: Complete
{end for}
```

---

## Next Step

**If `-st` flag is set:**
- Skip testing, read: `~/.claude/skills/apex/references/5-review.md`

**Otherwise:**
- Read and execute: `~/.claude/skills/apex/references/4-test.md`
