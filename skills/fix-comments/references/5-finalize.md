# Step 5: Finalize

React to comments and resolve all treated threads.

## Reactions (unless `-nr`)

For each treated comment, add reaction via REST API:

```bash
gh api repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions -f content="+1"  # implemented
gh api repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions -f content="-1"  # rejected
```

## Resolve ALL Treated Threads

**IMPORTANT**: Resolve threads for BOTH implemented AND rejected comments. Rejecting a comment is a valid resolution - it means you've addressed the feedback by deciding not to implement it.

For each treated thread (implemented or rejected):

```bash
gh api graphql -f query='mutation { resolveReviewThread(input: {threadId: "THREAD_ID"}) { thread { isResolved } } }'
```

## Next

- `-ss` flag or no code changes: stop
- Otherwise: read `~/.claude/skills/fix-comments/references/6-save.md`