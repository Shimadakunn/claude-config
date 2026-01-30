# Step 5: Review

Code review all changes using parallel specialist reviewers.

## Load Agents

Read all review agent definitions from `~/.claude/agents/review/`:
- `correctness.md` → instructions_correctness, model_correctness
- `security.md` → instructions_security, model_security
- `performance.md` → instructions_performance, model_performance
- `maintainability.md` → instructions_maintainability, model_maintainability

## Execute

Run 4 review agents in parallel (single message with multiple Task calls):

```javascript
Task({
  subagent_type: "review-correctness",
  model: model_correctness,
  prompt: `${instructions_correctness}\n\n---\nREVIEW CONTEXT:\n<diff>`,
  run_in_background: true
})
Task({
  subagent_type: "review-security",
  model: model_security,
  prompt: `${instructions_security}\n\n---\nREVIEW CONTEXT:\n<diff>`,
  run_in_background: true
})
Task({
  subagent_type: "review-performance",
  model: model_performance,
  prompt: `${instructions_performance}\n\n---\nREVIEW CONTEXT:\n<diff>`,
  run_in_background: true
})
Task({
  subagent_type: "review-maintainability",
  model: model_maintainability,
  prompt: `${instructions_maintainability}\n\n---\nREVIEW CONTEXT:\n<diff>`,
  run_in_background: true
})
```

## Aggregate

Collect and sort issues by severity:
1. **Critical**: Must fix before merge
2. **Major**: Should fix before merge
3. **Minor**: Nice to fix, not blocking

Display aggregated findings.

## Next

- Critical/Major issues found: read `~/.claude/skills/apex/references/6-resolve.md`
- No blocking issues: read `~/.claude/skills/apex/references/7-save.md`
