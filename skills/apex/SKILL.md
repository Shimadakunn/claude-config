---
name: apex
description: Systematic implementation workflow using APEX methodology (Analyze-Plan-Execute-eXamine). Use when implementing features, fixing bugs, refactoring code, or making any code changes. Triggers on requests like "implement", "build", "create", "add", "fix", "refactor", or when user invokes /apex. Orchestrates parallel exploration, planning, implementation, testing, review, and git operations.
disable-model-invocation: true
---

# APEX Workflow

**Explore → Plan → Implement → Test → Review → Resolve → Save**

## Initialization

At workflow start:

1. **Record start time**: Note when workflow began
2. **Create tasks** with `TaskCreate`:

```
TaskCreate: "Explore: Gather context"
TaskCreate: "Plan: Design approach"
TaskCreate: "Implement: Write code"
TaskCreate: "Test: Verify functionality"
TaskCreate: "Review: Check quality"
TaskCreate: "Resolve: Fix findings"
TaskCreate: "Save: Commit and PR"
```

## Phase Execution

For each phase:
1. `TaskUpdate` → status: `in_progress`
2. Read the reference file
3. Execute the phase
4. `TaskUpdate` → status: `completed`

| Phase        | Reference                                              | When to Skip                |
| ------------ | ------------------------------------------------------ | --------------------------- |
| 1. Explore   | [references/1-explore.md](references/1-explore.md)     | Trivial task, context known |
| 2. Plan      | [references/2-plan.md](references/2-plan.md)           | Single-file obvious change  |
| 3. Implement | [references/3-implement.md](references/3-implement.md) | Never                       |
| 4. Test      | [references/4-test.md](references/4-test.md)           | Non-functional changes      |
| 5. Review    | [references/5-review.md](references/5-review.md)       | Trivial changes             |
| 6. Resolve   | [references/6-resolve.md](references/6-resolve.md)     | No issues found             |
| 7. Save      | [references/7-save.md](references/7-save.md)           | User wants to continue      |

## Agents Available

| Agent        | Use For                                             |
| ------------ | --------------------------------------------------- |
| `explore`    | Codebase, documentation, or web research (parallel) |
| `plan`       | Synthesize findings, design implementation          |
| `implement`  | Writing/modifying code                              |
| `review-*`   | 4 parallel review dimensions                        |
| `save`       | Git commit, push, PR                                |

## Parallelization Rule

Independent work → spawn agents in single message (parallel).
Dependencies exist → sequential execution.

## Completion

At workflow end:

1. **Calculate duration**: End time - start time
2. **Display summary**:

```markdown
## APEX Complete

**Feature**: [description]
**Duration**: [time elapsed]
**Files changed**: [count]
**Commit**: [hash]
**PR**: [URL if created]

### Phases
- Explore: [skipped/completed]
- Plan: [skipped/completed]
- Implement: completed
- Test: [skipped/completed]
- Review: [skipped/completed] - [N issues found]
- Resolve: [skipped/completed]
- Save: [skipped/completed]
```
