# Step 1: Explore

**Purpose:** Gather context before implementation through parallel exploration.

---

## Execute Explorations in Parallel

Based on `workflow_state.exploration_plan.types`, spawn agents using the **Task tool**. Run all applicable explorations **in parallel** (single message with multiple Task calls).

### For `codebase` (unless `-nc` flag):

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Explore codebase"
  prompt: |
    You are the explore-codebase agent.
    Read and follow: ~/.claude/agents/explore/codebase.md

    TASK: {workflow_state.task}

    Find relevant code, patterns, architecture, and constraints.
    Return structured findings with file:line references.
```

### For `docs` (if libraries detected or `-doc` flag):

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Explore docs"
  prompt: |
    You are the explore-docs agent.
    Read and follow: ~/.claude/agents/explore/docs.md

    TASK: {workflow_state.task}
    LIBRARIES: {workflow_state.exploration_plan.libraries.join(", ")}

    Find API documentation, usage patterns, and best practices.
```

### For `web` (if URLs detected or `-web` flag):

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Web research"
  prompt: |
    You are the explore-web agent.
    Read and follow: ~/.claude/agents/explore/web.md

    TASK: {workflow_state.task}
    URLS: {workflow_state.exploration_plan.urls.join(", ") || "none - search the web"}

    Find solutions, patterns, and implementation guidance.
```

---

## Wait and Merge Results

1. Wait for all agent tasks to complete
2. Collect outputs from each agent
3. Merge into unified exploration output

## Store in Workflow State

```
workflow_state.exploration_output = {
  codebase: { ... },  // if ran
  docs: { ... },      // if ran
  web: { ... },       // if ran
  merged_insights: "...",
  merged_considerations: "..."
}
```

## Display Summary

```
Step 1: Explore - Complete
==========================
Sources: {exploration_plan.types.join(" + ")}

Key Insights:
{merged_insights}

Considerations:
{merged_considerations}
```

---

## Next Step

**If `-sp` flag is set:**
- Skip planning, read: `~/.claude/skills/apex/references/3-implement.md`

**Otherwise:**
- Read and execute: `~/.claude/skills/apex/references/2-plan.md`
