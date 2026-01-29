# Step 2: Review

Run parallel code review.

## Execute

Spawn 4 review agents in parallel:
- `review-correctness`
- `review-security`
- `review-performance`
- `review-maintainability`

## Aggregate

1. Merge all issues
2. Deduplicate (same file:line or overlapping concerns)
3. Sort by severity: critical → major → minor

## Next

- No issues: stop
- Otherwise: read `~/.claude/skills/review-pr/references/3-display.md`
