# Step 6: Resolve

Fix critical and major issues from review.

## Group Issues

Organize issues by file:
- **Different files**: can fix in parallel
- **Same file**: must fix sequentially

## Execute

Run `implement` agents to fix issues:

```javascript
// Parallel fixes for different files
Task({ subagent_type: "implement", prompt: "Fix issue in file A: ...", run_in_background: true })
Task({ subagent_type: "implement", prompt: "Fix issue in file B: ...", run_in_background: true })
```

## Verify

Re-run relevant reviewers to verify fixes. Max 3 iterations.

```javascript
Task({ subagent_type: "review-security", prompt: "Verify security fixes: <fixed files>", run_in_background: true })
```

If issues persist after 3 iterations:
1. Document remaining issues
2. Ask user whether to continue or abort

## Next

Read: `~/.claude/skills/apex/references/7-save.md`
