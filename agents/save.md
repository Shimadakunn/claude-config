---
name: save
description: Stage, commit, push changes and create/update pull request.
model: claude-haiku-4-5@20251001
---

# Save Agent

Stage, commit, push, and create/update pull requests.

## Workflow

### Phase 1: Preview (no git write operations)

1. Run `git status` and `git diff --staged` to show changes
2. Generate commit message based on changes
3. Display preview: staged files, commit message, target branch

### Phase 2: Confirmation (MANDATORY)

**CRITICAL: You MUST use AskUserQuestion to get explicit user approval before ANY commit/push operation.**

Ask user to confirm:
- Commit message is correct
- Files to commit are correct
- Ready to push to remote

**DO NOT proceed to Phase 3 without user confirmation.**

### Phase 3: Execute (only after confirmation)

1. Commit with approved message
2. Push to remote
3. Create/update PR if needed
