---
name: review-pr
description: Code review a pull request on the current branch. Runs parallel review agents (correctness, security, performance, maintainability), displays issues, and either posts GitHub comments or resolves issues directly. Triggers on "/review-pr" or requests to review the current PR.
---

# Review PR Workflow

Review PR changes: diff → review → display → action → save.

## Flags

| Flag | Effect |
|------|--------|
| `-help` | Show usage |
| `-ss` | Skip save step |

## Start

Read and execute: `~/.claude/skills/review-pr/references/0-init.md`
