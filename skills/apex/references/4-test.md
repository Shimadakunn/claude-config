# Step 4: Test

**Purpose:** Verify the implementation works correctly.

---

## Determine Test Mode

**If `-at` flag is set:** Automated testing mode
**Otherwise:** Manual testing mode (user verifies)

---

## Spawn Test Agent

Use the **Task tool**:

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Test implementation"
  prompt: |
    You are the test agent.
    Read and follow: ~/.claude/agents/test.md

    MODE: {"-at" in flags ? "automated" : "manual"}

    TASK: {workflow_state.task}

    IMPLEMENTATION SUMMARY:
    {workflow_state.implementation_output.summary}

    FILES MODIFIED:
    {workflow_state.implementation_output.files_modified.join("\n")}

    Generate test scenarios and execute them according to the mode.
    Return structured results with pass/fail for each scenario.
```

---

## Store in Workflow State

```
workflow_state.test_output = {
  mode: "automated" | "manual",
  scenarios: [...],
  passed: X,
  failed: Y,
  issues: [...]
}
```

## Display Summary

```
Step 4: Test - Complete
=======================

Mode: {test_output.mode}
Results: {test_output.passed}/{test_output.passed + test_output.failed} passed

{if test_output.failed > 0:}
Failed Scenarios:
{for each failed scenario:}
  - {scenario.name}: {scenario.failure_reason}
{end for}
{end if}
```

---

## Handle Test Failures

If tests failed:
1. Ask user how to proceed:
   - "Fix issues" → go back to implementation to fix
   - "Continue anyway" → proceed to review with warning
   - "Abort" → stop workflow

2. If fixing:
   - Create tasks for each failure
   - Read `3-implement.md` again
   - After fixes, re-run tests

---

## Next Step

**Read and execute:** `~/.claude/skills/apex/references/5-review.md`
