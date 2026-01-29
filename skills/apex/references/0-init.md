# Step 0: Initialize

## Help Mode

If `-help`: show flags and workflow steps, then stop.

## Resume Mode

If `-resume`: find last completed step and jump there.

## Parse Input

- Extract task and flags from user input
- Detect URLs → web exploration
- Detect library names → docs exploration
- Default → codebase exploration (unless `-nc`)

## Display

Show task, flags, and exploration plan.

## Next

Read: `~/.claude/skills/apex/references/1-explore.md`
