# Step 5: Review

Code review all changes using parallel specialist reviewers.

## Execute

Run 4 review agents in parallel (single message with multiple Task calls):

```javascript
Task({ subagent_type: "review-correctness", prompt: "Review changes for: <diff>", run_in_background: true })
Task({ subagent_type: "review-security", prompt: "Review changes for: <diff>", run_in_background: true })
Task({ subagent_type: "review-performance", prompt: "Review changes for: <diff>", run_in_background: true })
Task({ subagent_type: "review-maintainability", prompt: "Review changes for: <diff>", run_in_background: true })
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
