# Step 1: Explore

Gather context before implementation.

## Load Agent

Read the agent definition: `~/.claude/agents/explore.md`

Extract:
- **instructions**: The markdown content after frontmatter
- **model**: From frontmatter (opus/haiku/sonnet)

## Execute

Spawn the explore agent:

```
Task({
  subagent_type: "explore",
  model: <agent.model>,
  prompt: `
    ${agent.instructions}

    ---
    TASK CONTEXT:
    ${exploration_context_from_step_0}
  `
})
```

## Summarize

Display key findings:
- Relevant files and symbols
- API references and documentation
- Web solutions and patterns

## Next

Read: `~/.claude/skills/apex/references/2-plan.md`
