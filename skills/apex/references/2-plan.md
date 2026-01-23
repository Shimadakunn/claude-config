# Step 2: Plan

**Purpose:** Design the implementation approach before coding.

---

## Create Implementation Plan

Based on `workflow_state.exploration_output`, break down the task:

### For each subtask, define:

| Field | Description |
|-------|-------------|
| `id` | Unique task identifier (1, 2, 3...) |
| `description` | What needs to be accomplished |
| `files` | Files to modify or create |
| `requirements` | Specific requirements to fulfill |
| `edge_cases` | Edge cases to handle |
| `security_notes` | Security considerations |
| `acceptance_criteria` | How to verify completion |
| `dependencies` | Which tasks must complete first |

### Example Plan Structure:

```
workflow_state.plan = {
  tasks: [
    {
      id: 1,
      description: "Create user model with validation",
      files: ["src/models/user.ts"],
      requirements: ["Email validation", "Password hashing"],
      edge_cases: ["Duplicate email handling"],
      security_notes: ["Use bcrypt for passwords", "Sanitize email input"],
      acceptance_criteria: ["User can be created", "Duplicate email returns error"],
      dependencies: []
    },
    {
      id: 2,
      description: "Add authentication endpoints",
      files: ["src/routes/auth.ts"],
      requirements: ["Login endpoint", "Register endpoint"],
      edge_cases: ["Invalid credentials", "Rate limiting"],
      security_notes: ["JWT token expiry", "Secure cookie settings"],
      acceptance_criteria: ["Can register new user", "Can login and receive token"],
      dependencies: [1]
    }
  ]
}
```

---

## Present Plan to User

Display the plan and ask for approval:

```
Implementation Plan
===================

Task: {workflow_state.task}

Subtasks:
---------

{for each task in plan.tasks:}
[{task.id}] {task.description}
    Files: {task.files.join(", ")}
    Requirements: {task.requirements.join(", ")}
    Edge cases: {task.edge_cases.join(", ")}
    Security: {task.security_notes.join(", ")}
    Depends on: {task.dependencies.join(", ") || "none"}
{end for}

Total: {plan.tasks.length} subtasks
```

**Use AskUserQuestion:**
- "Approve plan" → proceed to implementation
- "Modify plan" → ask what to change, update plan
- "Add task" → ask for details, add to plan
- "Remove task" → ask which one, remove from plan

---

## Store in Workflow State

```
workflow_state.plan = { tasks: [...] }
workflow_state.plan_approved = true
```

---

## Next Step

**Read and execute:** `~/.claude/skills/apex/references/3-implement.md`
