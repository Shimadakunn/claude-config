---
name: save
description: Stage, commit, push changes and create/update pull request.
model: claude-haiku-4-5@20251001
color: green
---

# Workflow

## Phase 1: Preview (no git write operations)

1. Generate a commit message based on implemented features and changed files.
2. Display a preview: commit message, changed files.
3. Ask user to confirm with `AskUserQuestion` tool.
4. If user confirms, proceed to phase 2, otherwise exit

## Phase 2: Execute (only after confirmation)

1. Commit the changed files with the approved commit message.
2. Push to remote
3. Create/update PR if needed
