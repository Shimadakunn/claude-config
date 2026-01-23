---
description: Cleans up all git branches marked as [gone] (branches that have been deleted on the remote but still exist locally), including removing associated worktrees.
---

## Your Task

You need to execute the following bash commands to clean up stale local branches that have been deleted from the remote repository.

## Commands to Execute

1. **First, fetch from remote and prune deleted remote branches**
   Execute this command to update remote tracking info and mark branches as [gone] if their remote counterpart has been deleted:
   ```bash
   git fetch --prune
   ```

2. **List branches to identify any with [gone] status**
   Execute this command:
   ```bash
   git branch -vv
   ```

   Note: Branches with a '+' prefix have associated worktrees and must have their worktrees removed before deletion. The `[gone]` marker indicates the remote branch no longer exists.

3. **Identify worktrees that need to be removed for [gone] branches**
   Execute this command:
   ```bash
   git worktree list
   ```

4. **Finally, remove worktrees and delete [gone] branches (handles both regular and worktree branches)**
   Execute this command:
   ```bash
   # Process all [gone] branches, removing '+' prefix if present
   git branch -vv | grep '\[gone\]' | sed 's/^[+* ]//' | awk '{print $1}' | while read branch; do
     echo "Processing branch: $branch"
     # Find and remove worktree if it exists
     worktree=$(git worktree list | grep "\\[$branch\\]" | awk '{print $1}')
     if [ ! -z "$worktree" ] && [ "$worktree" != "$(git rev-parse --show-toplevel)" ]; then
       echo "  Removing worktree: $worktree"
       git worktree remove --force "$worktree"
     fi
     # Delete the branch
     echo "  Deleting branch: $branch"
     git branch -D "$branch"
   done
   ```

## Expected Behavior

After executing these commands, you will:

- Fetch latest remote info and prune deleted remote tracking branches
- See a list of all local branches with their remote tracking status
- Identify and remove any worktrees associated with [gone] branches
- Delete all branches marked as [gone] (branches whose remote counterpart no longer exists)
- Provide feedback on which worktrees and branches were removed

If no branches are marked as [gone], report that no cleanup was needed.

