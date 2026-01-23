# Step 6: Resolve

**Purpose:** Fix Critical and Major issues found during review.

---

## Get Issues to Fix

From `workflow_state.review_output.issues`, filter for:
- Severity: `Critical` or `Major`

Group issues by file for efficient fixing.

---

## Create Fix Tasks

For each issue or group of related issues:

```
fix_tasks = [
  {
    id: 1,
    description: "Fix {issue.description}",
    file: "{issue.file}",
    line: {issue.line},
    issue_type: "{issue.category}",  // correctness, security, performance, maintainability
    fix_guidance: "{issue.fix}"
  },
  ...
]
```

---

## Execute Fixes

For each fix task, use the **Task tool**:

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Fix: {fix_task.description}"
  prompt: |
    You are the implement agent.
    Read and follow: ~/.claude/agents/implement.md

    FIX TASK:
    - File: {fix_task.file}
    - Line: {fix_task.line}
    - Issue: {fix_task.description}
    - Category: {fix_task.issue_type}
    - Fix guidance: {fix_task.fix_guidance}

    Apply the fix following quality criteria.
    Ensure the fix doesn't introduce new issues.
    Return the changes made.
```

---

## Verify Fixes

After all fixes are applied:

1. Re-run the relevant review agent(s) for the affected category
2. If new issues found → create more fix tasks
3. If all clear → proceed

**Example verification:**
```
Task tool call:
  subagent_type: "general-purpose"
  description: "Verify fixes"
  prompt: |
    You are the review-{category} agent.
    Read and follow: ~/.claude/agents/review/{category}.md

    Verify the following issues have been fixed:
    {list of original issues}

    FILES: {fixed_files.join("\n")}

    Return: confirmed fixed or still present for each issue.
```

---

## Store in Workflow State

```
workflow_state.resolve_output = {
  issues_fixed: X,
  issues_remaining: Y,
  iterations: Z
}
```

## Display Summary

```
Step 6: Resolve - Complete
==========================

Issues fixed: {issues_fixed}
Remaining: {issues_remaining}
Iterations: {iterations}

{if issues_remaining > 0:}
Warning: Some issues could not be resolved automatically.
Remaining issues:
{for each remaining issue:}
  - {issue.file}:{issue.line}: {issue.description}
{end for}
{end if}
```

---

## Next Step

**Read and execute:** `~/.claude/skills/apex/references/7-save.md`
