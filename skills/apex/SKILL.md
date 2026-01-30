---
name: apex
description: Systematic implementation workflow using APEX methodology (Analyze-Plan-Execute-eXamine). Use when implementing features, fixing bugs, refactoring code, or making any code changes. Triggers on requests like "implement", "build", "create", "add", "fix", "refactor", or when user invokes /apex. Orchestrates parallel exploration, planning, implementation, testing, review, and git operations.
---

# APEX Workflow

Complete coding workflow: **Explore → Plan → Implement → Test → Review → Resolve → Save**

## Workflow Phases

| Phase | Purpose | Parallelization |
|-------|---------|-----------------|
| 1. Explore | Gather context from codebase, docs, web | Parallel agents |
| 2. Plan | Design implementation approach | Sequential |
| 3. Implement | Write the code | Parallel agents |
| 4. Test | Verify feature works | User validation |
| 5. Review | Check quality (4 dimensions) | Parallel agents |
| 6. Resolve | Fix review findings | Parallel agents |
| 7. Save | Commit, push, create PR | Sequential |

## Phase Details

Each phase has a dedicated reference file. Read the relevant file before executing each phase.

### 1. Explore
Read [references/1-explore.md](references/1-explore.md) for exploration strategy.

Launch parallel Task agents to gather context:
- **Codebase exploration**: Find relevant files, patterns, dependencies
- **Documentation lookup**: Query Context7 for library docs
- **Web research**: Search for solutions, best practices

Consolidate findings before proceeding.

### 2. Plan
Read [references/2-plan.md](references/2-plan.md) for planning approach.

Use `EnterPlanMode` or the Plan subagent to design the implementation. The plan should identify:
- Files to modify/create
- Key changes per file
- Dependencies between changes
- Potential risks

### 3. Implement
Read [references/3-implement.md](references/3-implement.md) for implementation strategy.

Execute the plan using parallel Task agents when changes are independent. Group by:
- File boundaries
- Feature boundaries
- Layer boundaries (frontend/backend)

### 4. Test
Read [references/4-test.md](references/4-test.md) for testing approach.

Ask the user to validate the feature works. Use `AskUserQuestion` to confirm functionality before proceeding to review.

### 5. Review
Read [references/5-review.md](references/5-review.md) for review protocol.

Launch 4 parallel review agents:
- `review-correctness`: Logic, edge cases, error handling
- `review-security`: OWASP vulnerabilities, input validation
- `review-performance`: Efficiency, resource usage
- `review-maintainability`: Clarity, consistency, patterns

Reviews exchange findings to avoid redundancy.

### 6. Resolve
Read [references/6-resolve.md](references/6-resolve.md) for resolution strategy.

Address review findings using parallel Task agents. Prioritize by severity:
1. Security issues (critical)
2. Correctness issues (high)
3. Performance issues (medium)
4. Maintainability issues (low)

### 7. Save
Read [references/7-save.md](references/7-save.md) for git operations.

Commit changes, push to remote, create PR if none exists. Use the `save` subagent or follow git workflow manually.
