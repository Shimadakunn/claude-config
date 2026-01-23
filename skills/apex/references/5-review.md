# Step 5: Review

**Purpose:** Code review all changes for quality issues.

---

## Spawn Review Agents in Parallel

Use the **Task tool** with **4 parallel calls** (single message, multiple tool invocations):

### 1. Correctness Review

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Review correctness"
  prompt: |
    You are the review-correctness agent.
    Read and follow: ~/.claude/agents/review/correctness.md

    Review the recent changes for:
    - Logic errors
    - Missing edge cases
    - Error handling issues
    - Type safety problems

    FILES TO REVIEW:
    {workflow_state.implementation_output.files_modified.join("\n")}

    Return issues in table format with severity, file:line, issue, fix.
```

### 2. Security Review

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Review security"
  prompt: |
    You are the review-security agent.
    Read and follow: ~/.claude/agents/review/security.md

    Review the recent changes for:
    - Injection vulnerabilities
    - Authentication/authorization issues
    - Sensitive data exposure
    - Hardcoded secrets

    FILES TO REVIEW:
    {workflow_state.implementation_output.files_modified.join("\n")}

    Return issues in table format with severity, OWASP category, file:line, issue, fix.
```

### 3. Performance Review

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Review performance"
  prompt: |
    You are the review-performance agent.
    Read and follow: ~/.claude/agents/review/performance.md

    Review the recent changes for:
    - Algorithmic complexity issues
    - N+1 queries
    - Memory leaks
    - Blocking operations

    FILES TO REVIEW:
    {workflow_state.implementation_output.files_modified.join("\n")}

    Return issues in table format with severity, impact, file:line, issue, fix.
```

### 4. Maintainability Review

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Review maintainability"
  prompt: |
    You are the review-maintainability agent.
    Read and follow: ~/.claude/agents/review/maintainability.md

    Review the recent changes for:
    - Code duplication
    - Naming consistency
    - Function complexity
    - Magic numbers

    FILES TO REVIEW:
    {workflow_state.implementation_output.files_modified.join("\n")}

    Return issues in table format with severity, file:line, issue, fix.
```

---

## Aggregate Results

1. Wait for all 4 review agents to complete
2. Merge all issues into a single list
3. Sort by severity: Critical → Major → Minor

## Store in Workflow State

```
workflow_state.review_output = {
  issues: [...],
  counts: {
    critical: X,
    major: Y,
    minor: Z
  }
}
```

## Display Summary

```
Step 5: Review - Complete
=========================

Issues Found:
  Critical: {counts.critical}
  Major: {counts.major}
  Minor: {counts.minor}

{if counts.critical > 0 || counts.major > 0:}
Issues Requiring Resolution:
{for each issue where severity in ["Critical", "Major"]:}
  [{issue.severity}] {issue.file}:{issue.line}
    {issue.description}
    Fix: {issue.fix}
{end for}
{end if}
```

---

## Next Step

**If Critical or Major issues found:**
- Read and execute: `~/.claude/skills/apex/references/6-resolve.md`

**Otherwise:**
- Skip resolve, read: `~/.claude/skills/apex/references/7-save.md`
