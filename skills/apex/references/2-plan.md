# Plan Phase

Synthesize exploration findings and design implementation approach using the `plan` agent.

## Task Tracking

```
TaskUpdate(taskId: "plan", status: "in_progress")
```

## Process

### 1. Spawn Plan Agent

Pass the exploration findings to the plan agent:

```
Task(subagent_type=plan, description="Design implementation plan"):
"EXPLORATION FINDINGS:
[Paste synthesized findings from explore phase]

FEATURE: [feature description]

USER REQUIREMENTS:
[Any specific requirements from user]

Design an implementation plan that:
1. Synthesizes the exploration context
2. Identifies files to create/modify
3. Sequences work by dependencies
4. Documents key decisions and risks"
```

### 2. Plan Agent Output

The plan agent (in plan mode) will return:

- **Summary**: Overview of what will be implemented
- **Changes**: Files to create/modify with purposes
- **Implementation Order**: Sequenced steps with parallelization notes
- **Decisions**: Technology choices with rationale
- **Risks**: Potential issues with mitigations
- **Test Plan**: Verification checklist

### 3. Pass to Implement Phase

Take the plan output and pass it to the Implement phase (3-implement.md).

The plan provides the structure for spawning parallel implementation agents.

## Completion

```
TaskUpdate(taskId: "plan", status: "completed")
```

## Skip When

- Single-file obvious change
- User provides explicit instructions
- Continuation of existing work

If skipping: `TaskUpdate(taskId: "plan", status: "completed", description: "Skipped: [reason]")`
