# Resolve Phase

Fix review findings using `implement` agents.

## Task Tracking

```
TaskUpdate(taskId: "resolve", status: "in_progress")
```

## Process

### 1. Parse Review Findings

From the consolidated review, extract issues to fix:

```
ISSUES TO RESOLVE:

Critical:
- [file:line] Issue description → Fix approach

High:
- [file:line] Issue description → Fix approach

Medium:
- [file:line] Issue description → Fix approach
```

### 2. Group by Parallelization

**Parallel when:**
- Issues in different files
- Independent fixes in same file

**Sequential when:**
- One fix depends on another
- Same code section affected

### 3. Spawn Implement Agents

Launch parallel fixes in **single message**:

```
Task(subagent_type=implement, description="Fix [issue type]"):
"TASK: Fix review findings

ISSUES TO FIX:
1. [file:line] Issue description
   - Problem: [why it's an issue]
   - Fix: [how to resolve]

2. [file:line] Issue description
   - Problem: [why it's an issue]
   - Fix: [how to resolve]

FILES:
- path/file.ts

REQUIREMENTS:
- Fix the specific issues identified
- Do not change unrelated code
- Maintain existing patterns"
```

### 4. Example

Given review findings:
```
Critical:
- src/auth/jwt.ts:42 - SQL injection in query

High:
- src/middleware/auth.ts:15 - Missing null check
- src/types/user.ts:8 - Incorrect type definition

Medium:
- src/auth/jwt.ts:60 - N+1 query pattern
```

**Spawn parallel** (different files):

```
Task(subagent_type=implement, description="Fix jwt.ts issues"):
"TASK: Fix review findings in jwt.ts

ISSUES TO FIX:
1. [line 42] SQL injection - use parameterized query
2. [line 60] N+1 query - batch the queries

FILES: src/auth/jwt.ts"

Task(subagent_type=implement, description="Fix auth.ts issues"):
"TASK: Fix review findings in auth.ts

ISSUES TO FIX:
1. [line 15] Missing null check - add guard clause

FILES: src/middleware/auth.ts"

Task(subagent_type=implement, description="Fix user.ts issues"):
"TASK: Fix review findings in user.ts

ISSUES TO FIX:
1. [line 8] Incorrect type - fix type definition

FILES: src/types/user.ts"
```

### 5. Verify Fixes

After implement agents complete:

1. **Summarize** what was fixed
2. **Confirm** each issue was addressed
3. **Check** for any new issues introduced

### 6. Proceed to Save

Once all issues resolved → Proceed to Save phase (7-save.md)

## Completion

```
TaskUpdate(taskId: "resolve", status: "completed", description: "[N] issues fixed")
```

## Skip When

- Review found no issues
- Only low-priority issues and user chose to skip

If skipping: `TaskUpdate(taskId: "resolve", status: "completed", description: "Skipped: no issues")`
