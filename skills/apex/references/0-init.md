# Step 0: Initialize

## If `-help` flag is present, show this and STOP:

```
APEX - Systematic Implementation Workflow
==========================================

Usage: /apex [task description] [flags]

Flags:
  -help    Show this help message
  -doc     Force documentation exploration
  -web     Force web exploration
  -nc      Skip codebase exploration (no-code)
  -sp      Skip planning phase (direct implementation)
  -at      Use automatic tests instead of manual
  -st      Skip testing phase entirely

Smart Detection:
  APEX automatically detects what to explore based on your input:
  - URLs (https://...) → web exploration
  - Library mentions (using React, with Prisma) → docs exploration
  - All tasks → codebase exploration (unless -nc flag)

Workflow Steps:
  1. Explore   → Gather context (codebase/docs/web)
  2. Plan      → Design implementation approach
  3. Implement → Write the code
  4. Test      → Validate the implementation
  5. Review    → Code review all changes
  6. Resolve   → Fix review issues
  7. Save      → Commit and create/update PR

Examples:
  /apex implement user authentication
  /apex fix login bug using https://example.com/solution
  /apex add Redis caching
  /apex -nc -doc integrate Stripe payments
```

**If `-help` was present, STOP HERE. Do not continue.**

---

## Smart Detection

Analyze the task to build an exploration plan:

1. **Detect URLs** (pattern: `https?://...`)
   - If found → add `web` to exploration types
   - Store URLs for the web agent

2. **Detect libraries/frameworks** (React, Vue, Prisma, Redis, Stripe, Next.js, etc.)
   - If found → add `docs` to exploration types
   - Store library names for the docs agent

3. **Codebase exploration**
   - Unless `-nc` flag → add `codebase` to exploration types

4. **Flag overrides**
   - `-doc` → force add `docs`
   - `-web` → force add `web`

## Store Workflow State

```
workflow_state = {
  task: "{parsed_task}",
  flags: ["{parsed_flags}"],
  exploration_plan: {
    types: ["codebase", "docs", "web"],  // as detected
    urls: [...],      // if any
    libraries: [...]  // if any
  }
}
```

## Display Workflow Start

```
Starting APEX workflow
======================
Task: {task}
Flags: {flags or "none"}

Exploration Plan:
  {exploration_plan.types.join(" + ")}

Steps to execute:
  [1] Explore   ({exploration_plan.types.join(" + ")})
  [2] Plan      {"-sp" in flags ? "(skipped)" : ""}
  [3] Implement
  [4] Test      {"-st" in flags ? "(skipped)" : "-at" in flags ? "(automatic)" : "(manual)"}
  [5] Review
  [6] Resolve   (if issues found)
  [7] Save
```

---

## Next Step

**Read and execute:** `~/.claude/skills/apex/references/1-explore.md`
