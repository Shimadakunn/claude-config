# Implement Phase

Take the plan from the Plan phase and execute through parallel `implement` agents.

## Task Tracking

```
TaskUpdate(taskId: "implement", status: "in_progress")
```

## Process

### 1. Parse the Plan

From the plan output, extract:

- **Changes table**: Files to create/modify
- **Implementation Order**: Which steps can parallelize
- **Decisions**: Technology choices to follow
- **Patterns**: Conventions identified in exploration

### 2. Group Parallelizable Tasks

Analyze the Implementation Order section to identify:

**Parallel when:**
- Files have no imports between them
- Separate modules/layers
- Independent features
- Plan marks as "can parallelize with X"

**Sequential when:**
- One file imports from another being created
- Plan marks as "depends on step X"
- Schema/types before code using them
- Config before dependent code

### 3. Spawn Parallel Implement Agents

Launch all independent tasks in a **single message**:

```
Task(subagent_type=implement, description="[Component name]"):
"TASK: [What to implement]

FILES:
- path/file.ts - Create/Modify

REQUIREMENTS:
- [Requirement from plan]
- [Requirement from plan]

PATTERNS TO FOLLOW:
- [Pattern from exploration]
- [Convention to match]

CONTEXT:
[Relevant exploration findings for this task]"
```

### 4. Handle Sequential Dependencies

After parallel batch completes, spawn next batch that depended on them:

```
# After parallel tasks complete...

Task(subagent_type=implement, description="[Dependent component]"):
"TASK: [What to implement]

DEPENDS ON: [What was just completed]

FILES:
- path/file.ts - Create/Modify

REQUIREMENTS:
- [Requirements]

IMPORTS FROM:
- [Files created in previous batch]"
```

## Example

Given plan with Implementation Order:
```
1. JWT utilities - can parallelize with 2
2. User types - can parallelize with 1
3. Auth middleware - depends on 1, 2
```

**Batch 1** (single message, parallel):
```
Task(subagent_type=implement, description="JWT utilities"):
"TASK: Create JWT sign/verify utilities
FILES: src/auth/jwt.ts - Create
REQUIREMENTS: sign, verify, decode functions using jose library
PATTERNS: Match existing utility patterns"

Task(subagent_type=implement, description="User types"):
"TASK: Create User type definitions
FILES: src/types/user.ts - Create
REQUIREMENTS: User interface with id, email, role, timestamps"
```

**Batch 2** (after batch 1 completes):
```
Task(subagent_type=implement, description="Auth middleware"):
"TASK: Create authentication middleware
FILES: src/middleware/auth.ts - Create
DEPENDS ON: JWT utilities, User types
REQUIREMENTS: Verify JWT from header, attach user to request
IMPORTS FROM: src/auth/jwt.ts, src/types/user.ts"
```

## Completion

```
TaskUpdate(taskId: "implement", status: "completed")
```

## Quality Checks

Each implement agent should:
- Follow existing patterns from exploration
- Handle errors appropriately
- Avoid over-engineering
- Stay focused on task requirements
- Not modify files outside its scope
