# Review Phase

Review implemented code through 4 parallel review agents, then consolidate and present findings.

## Task Tracking

```
TaskUpdate(taskId: "review", status: "in_progress")
```

## Process

### 1. Identify Files to Review

From the implementation summary, list all files created/modified:
```
FILES TO REVIEW:
- src/auth/jwt.ts
- src/middleware/auth.ts
- src/types/user.ts
```

### 2. Spawn 4 Review Agents in Parallel

Launch all in a **single message**:

```
Task(subagent_type=review-correctness, description="Correctness review"):
"FILES TO REVIEW:
[list of files]

FEATURE CONTEXT:
[Brief description of what was implemented]

Review for logic errors, edge cases, and error handling."

Task(subagent_type=review-security, description="Security review"):
"FILES TO REVIEW:
[list of files]

FEATURE CONTEXT:
[Brief description of what was implemented]

Review for OWASP vulnerabilities, input validation, and auth issues."

Task(subagent_type=review-performance, description="Performance review"):
"FILES TO REVIEW:
[list of files]

FEATURE CONTEXT:
[Brief description of what was implemented]

Review for inefficiencies, N+1 queries, and resource usage."

Task(subagent_type=review-maintainability, description="Maintainability review"):
"FILES TO REVIEW:
[list of files]

FEATURE CONTEXT:
[Brief description of what was implemented]

Review for clarity, consistency, and patterns."
```

### 3. Gather and Deduplicate Findings

After all agents complete:

1. **Collect** findings from each agent
2. **Deduplicate** - same issue reported by multiple agents
3. **Merge** related findings into single items
4. **Sort** by severity: Critical → High → Medium → Low

### 4. Present Consolidated Review

Display to user:

```markdown
## Code Review Summary

### Critical Issues (must fix)
- [file:line] **[Type]** Issue description
  - Problem: Why it's an issue
  - Fix: How to resolve

### High Priority
- [file:line] **[Type]** Issue description
  - Problem: Why it's an issue
  - Fix: How to resolve

### Medium Priority
- ...

### Low Priority (optional)
- ...

### No Issues Found
- [Category]: ✓ Passed
```

### 5. Determine Next Step

**If Critical or High issues found:**
→ Proceed to Resolve phase (6-resolve.md)

**If only Medium/Low or no issues:**
→ Ask user if they want to fix or proceed to Save phase

```
AskUserQuestion:
  question: "Review found [N] medium/low issues. How to proceed?"
  header: "Review"
  options:
    - label: "Fix issues"
      description: "Resolve the findings before saving"
    - label: "Skip and save"
      description: "Accept as-is and proceed to commit"
```

## Completion

```
TaskUpdate(taskId: "review", status: "completed", description: "[N] issues found")
```

## Skip When

- Trivial changes (typos, comments only)
- User explicitly requests skipping review

If skipping: `TaskUpdate(taskId: "review", status: "completed", description: "Skipped: [reason]")`
