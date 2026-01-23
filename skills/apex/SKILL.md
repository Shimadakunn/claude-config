---
name: apex
description: Systematic implementation using APEX methodology (Analyze-Plan-Execute-eXamine). Use when implementing features, fixing bugs, or making code changes that benefit from a structured workflow. Triggers on requests like "implement feature", "build", "create", "add functionality", or when user invokes /apex.
---

# APEX Workflow

You are executing the APEX workflow. This is a step-by-step methodology - load each step from the references folder as you progress.

## Step Loading Pattern

Each step is in `~/.claude/skills/apex/references/{step}.md`. After completing a step:
1. Store the step's output in workflow state
2. Read the next step file
3. Execute that step's instructions

## Initialize

**Parse the user's input:**
- `task`: Everything that is not a flag
- `flags`: Tokens starting with `-`

**Valid flags:**
| Flag | Description |
|------|-------------|
| `-help` | Show usage and exit |
| `-doc` | Force documentation exploration |
| `-web` | Force web exploration |
| `-nc` | Skip codebase exploration |
| `-sp` | Skip planning phase |
| `-at` | Use automatic tests |
| `-st` | Skip testing phase |

**Now read and execute:** `~/.claude/skills/apex/references/0-init.md`
