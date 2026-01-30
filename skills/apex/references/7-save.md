# Save Phase

Commit changes and create PR using the `save` agent.

## Task Tracking

```
TaskUpdate(taskId: "save", status: "in_progress")
```

## Process

### 1. Prepare Context

Gather from previous phases:
- **Feature**: What was implemented
- **Files changed**: List from implementation
- **Key changes**: Summary of what was done

### 2. Spawn Save Agent

```
Task(subagent_type=save, description="Commit and create PR"):
"FEATURE: [feature description]

FILES CHANGED:
- path/file.ts - [what was done]
- path/file.ts - [what was done]

SUMMARY:
[Brief description of changes for commit message]

Commit the changes, push to remote, and create a pull request."
```

### 3. Save Agent Actions

The save agent will:

1. **Preview** - Run `git status` and `git diff`
2. **Generate** - Create commit message from changes
3. **Confirm** - Ask user to approve with `AskUserQuestion`
4. **Stage** - Add specific files (not `git add -A`)
5. **Commit** - With approved message
6. **Push** - To remote with `-u` flag
7. **PR** - Create pull request if none exists

### 4. Output

Save agent returns:
- Commit hash
- PR URL (if created)
- Any issues encountered

## Commit Message Format

```
<type>: <short description>

<optional body explaining why>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

## PR Format

```markdown
## Summary
- <bullet points of changes>

## Test plan
- [ ] <testing steps>
```

## Completion

```
TaskUpdate(taskId: "save", status: "completed", description: "Committed: [hash]")
```

## Skip When

- User wants to continue working
- Changes are work-in-progress
- User explicitly requests not to commit

If skipping: `TaskUpdate(taskId: "save", status: "completed", description: "Skipped: [reason]")`
