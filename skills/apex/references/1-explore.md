# Step 1: Explore

Gather context before implementation.

## Execute

Spawn an `explore` agent with the exploration context from Step 0:

```
Task(subagent_type="explore", prompt="<exploration context from step 0>")
```

The agent will:
- Detect which exploration types are needed (codebase, docs, web)
- Spawn appropriate sub-agents in parallel
- Consolidate findings

## Summarize

Display key findings:
- Relevant files and symbols
- API references and documentation
- Web solutions and patterns

## Next

Read: `~/.claude/skills/apex/references/2-plan.md`
