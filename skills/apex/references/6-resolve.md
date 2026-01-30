# Step 6: Resolve

Fix critical and major issues from review.

## Load Agent

Read the implement agent: `~/.claude/agents/implement.md`
Read relevant review agents from `~/.claude/agents/review/` (based on which found issues)

## Group Issues

Organize issues by file:
- **Different files**: can fix in parallel
- **Same file**: must fix sequentially

## Execute

Run implement agents to fix issues:

```javascript
// Parallel fixes for different files
Task({
  subagent_type: "implement",
  model: implement_agent.model,
  prompt: `${implement_agent.instructions}\n\n---\nFIX ISSUE:\nFile: A\nIssue: ...`,
  run_in_background: true
})
Task({
  subagent_type: "implement",
  model: implement_agent.model,
  prompt: `${implement_agent.instructions}\n\n---\nFIX ISSUE:\nFile: B\nIssue: ...`,
  run_in_background: true
})
```

## Verify

Re-run relevant reviewers to verify fixes. Max 3 iterations.

```javascript
Task({
  subagent_type: "review-security",
  model: security_agent.model,
  prompt: `${security_agent.instructions}\n\n---\nVERIFY FIXES:\n<fixed files>`,
  run_in_background: true
})
```

If issues persist after 3 iterations:
1. Document remaining issues
2. Ask user whether to continue or abort

## Next

Read: `~/.claude/skills/apex/references/7-save.md`
