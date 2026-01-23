# Step 7: Save

**Purpose:** Commit changes and create/update pull request.

---

## Spawn Save Agent

Use the **Task tool**:

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Commit and PR"
  prompt: |
    You are the save agent.
    Read and follow: ~/.claude/agents/save.md

    IMPLEMENTATION SUMMARY:
    Task: {workflow_state.task}

    Changes made:
    {workflow_state.implementation_output.summary}

    Files modified:
    {workflow_state.implementation_output.files_modified.join("\n")}

    Review results:
    - Issues found: {workflow_state.review_output.counts.critical + workflow_state.review_output.counts.major + workflow_state.review_output.counts.minor}
    - Issues fixed: {workflow_state.resolve_output?.issues_fixed || 0}

    Test results:
    - Passed: {workflow_state.test_output?.passed || "N/A"}
    - Failed: {workflow_state.test_output?.failed || "N/A"}

    Execute the save workflow:
    1. Stage changes (with user confirmation)
    2. Commit (with user confirmation on message)
    3. Push to remote
    4. Create/update PR (with user confirmation)

    Return: commit SHA, branch name, PR URL
```

---

## Store in Workflow State

```
workflow_state.save_output = {
  commit_sha: "...",
  branch: "...",
  pr_url: "...",
  pr_title: "..."
}
```

---

## Workflow Complete

Display final summary:

```
APEX Workflow Complete
======================

Task: {workflow_state.task}
Flags: {workflow_state.flags.join(" ") || "none"}

Summary
-------
  Explore:   {workflow_state.exploration_plan.types.join(" + ")}
  Plan:      {workflow_state.plan?.tasks.length || "skipped"} tasks
  Implement: {workflow_state.implementation_output.files_modified.length} files modified
  Test:      {workflow_state.test_output?.passed || "skipped"}/{workflow_state.test_output?.passed + workflow_state.test_output?.failed || ""} passed
  Review:    {workflow_state.review_output.counts.critical}C/{workflow_state.review_output.counts.major}M/{workflow_state.review_output.counts.minor}m issues
  Resolve:   {workflow_state.resolve_output?.issues_fixed || 0} issues fixed
  Save:      Committed and pushed

Commit: {workflow_state.save_output.commit_sha}
Branch: {workflow_state.save_output.branch}
PR:     {workflow_state.save_output.pr_url}
```

---

## Workflow End

**The APEX workflow is complete. Do not load any more steps.**
