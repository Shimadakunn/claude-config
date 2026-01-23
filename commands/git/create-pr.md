---
allowed-tools: Bash(git :*), Bash(gh :*), AskUserQuestion
description: Create or update PR with auto-generated title and description
model: haiku
argument: Optional base branch name (defaults to main if not provided)
---

You are a PR automation tool. Create pull requests with concise, meaningful descriptions.

## Arguments

- `$ARGUMENTS`: Optional base branch name for the PR
  - If provided: Use `origin/$ARGUMENTS` as the base branch
  - If empty/null: Use `origin/main` as the base branch

## Context

- Current branch: !`git branch --show-current`
- Working tree status: !`git status --short`
- Recent commits: !`git log --oneline -5`
- Remote tracking: !`git rev-parse --abbrev-ref @{upstream} 2>/dev/null || echo "none"`
- Base branch: `origin/${ARGUMENTS:-main}` (use this for all comparisons)

## Workflow

1. **Determine Base**: Set base branch to `origin/$ARGUMENTS` if argument provided, otherwise `origin/main`
2. **Verify**: `git status` and `git branch --show-current` to check state
3. **Check Existing PR**: Run `gh pr view --json number,title,body,url 2>/dev/null` to check if a PR already exists for this branch
   - If PR exists: Jump to **Update PR Flow** below
   - If no PR: Continue with creation flow
4. **Branch Safety**: **CRITICAL** - Ensure not on main/master branch
   - If on `main` or `master`: Create descriptive branch from changes
   - Analyze staged files to generate meaningful branch name
   - **NEVER** commit directly to protected branches
5. **Push**: `git push -u origin HEAD` to ensure remote tracking
6. **Analyze**: `git diff <base>...HEAD --stat` to understand changes (replace `<base>` with determined base branch)
7. **Generate**: Create PR with:
   - Title: One-line summary (max 72 chars)
   - Body: Bullet points of key changes
8. **Preview & Approve**:
   - First, display a summary to the user showing:
     - Number of commits to be included (count from `git rev-list --count <base>..HEAD`)
     - All commits listed (`git log <base>..HEAD --oneline`)
     - The proposed PR title
     - The proposed PR description/body
   - Then use `AskUserQuestion` to ask for approval with options: "Create PR", "Edit details", "Cancel"
9. **Submit**: Only after user approval, run `gh pr create --base <base-branch-name> --title "..." --body "..."`
10. **Return**: Display PR URL

## Update PR Flow (when PR already exists)

1. **Display Current PR**: Show the user the existing PR details:
   - PR number and URL
   - Current title
   - Current body/description
2. **Analyze Changes**: `git diff <base>...HEAD --stat` to understand all changes in the branch
3. **Generate New Content**: Based on the current branch state, generate:
   - New title: One-line summary (max 72 chars)
   - New body: Bullet points of key changes (same format as creation)
4. **Preview & Compare**: Display to the user:
   - **Current title** vs **Proposed title**
   - **Current body** vs **Proposed body**
   - Highlight what will change
5. **Ask Approval**: Use `AskUserQuestion` to ask for approval with options:
   - "Update PR" - Apply the changes
   - "Edit details" - Let user modify before updating
   - "Keep current" - Cancel, keep existing PR unchanged
6. **Update**: Only after user approval, run `gh pr edit --title "..." --body "..."`
7. **Return**: Display updated PR URL

## PR Format

```markdown
## Summary

• [Main change or feature]
• [Secondary changes]
• [Any fixes included]

## Type

[feat/fix/refactor/docs/chore]
```

## Execution Rules

- **MANDATORY**: Get user approval before creating OR updating PR - never skip this step
- **IGNORE unstaged/uncommitted files**: Only consider existing commits when creating/updating the PR - do not stage, commit, or include any pending changes
- NO verbose descriptions
- NO "Generated with" signatures
- Auto-detect base branch (main/master/develop)
- Use HEREDOC for multi-line body
- If PR exists, offer to update it (with approval) instead of failing

## Priority

Clarity > Completeness. Keep PRs scannable and actionable.

---

User: #$ARGUMENTS
