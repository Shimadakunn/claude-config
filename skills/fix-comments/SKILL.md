---
name: fix-comments
description: Fetch unresolved PR review comments, critically analyze their relevance, implement approved fixes, and react to comments. Triggers on "/fix-comments" or requests to address PR feedback.
---

# Fix Comments Workflow

Handle PR review comments: fetch → analyze → implement → finalize → save.

## Flags

| Flag | Effect |
|------|--------|
| `-help` | Show usage |
| `-all` | Skip analysis, implement all |
| `-ss` | Skip save step |
| `-nr` | No reactions |

## Start

Read and execute: `~/.claude/skills/fix-comments/references/0-init.md`
