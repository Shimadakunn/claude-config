---
allowed-tools: Bash(git :*), Bash(gh :*), Read, Grep, Glob, AskUserQuestion, Edit
description: Code review a pull request
---

You are performing a code review on the changes in the current branch.

## Getting the Diff

First, get the diff between the PR branch and the base/reference branch:

1. **Identify the PR** - Use `gh pr view --json number,baseRefName,headRefName` to get PR details.
2. **Get the diff** - Run `git diff <base-branch>...HEAD` to see all changes in the PR.
3. **Review file-by-file** - You can also use `gh pr diff` to get the PR diff directly.

## Code Review Instructions

When reviewing the diff:

1. **Focus on logic and correctness** - Check for bugs, edge cases, and potential issues.
2. **Consider readability** - Is the code clear and maintainable? Does it follow best practices in this repository?
3. **Evaluate performance** - Are there obvious performance concerns or optimizations that could be made?
4. **Assess test coverage** - Does the repository have testing patterns? If so, are there adequate tests for these changes?
5. **Ask clarifying questions** - Ask the user for clarification if you are unsure about the changes or need more context.
6. **Don't be overly pedantic** - Nitpicks are fine, but only if they are relevant issues within reason.

## Review Summary & Approval

Before posting comments to GitHub, you MUST:

1. **Display a summary** showing:
   - PR number and title
   - Number of files changed
   - Total issues found (grouped by severity: critical, warning, suggestion)
   - A table of all issues with: index, file, line(s), severity, issue description

2. **Ask for approval** using `AskUserQuestion` with options:
   - "Post all comments" - Post all identified issues as review comments
   - "Select which to post" - Let user choose specific issues to post
   - "Fix issues directly" - Fix the issues in the code without posting comments (do not commit changes)
   - "Skip posting" - Don't post comments, just show the summary

3. **Only post after approval** - Never post comments to GitHub without explicit user confirmation

## Output Format

In your summary output:

- Provide a summary overview of the general code quality.
- Present the identified issues in a table with columns: index, severity, file:line, issue, suggestion.
- If no issues are found, briefly state that the code meets best practices.

## Posting Comments to GitHub

After user approval, post issues as review comments directly on the PR:

1. **Single-line comment**:
   ```bash
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments \
     --method POST \
     -f body="<comment>" \
     -f path="<file_path>" \
     -f commit_id="$(git rev-parse HEAD)" \
     -F line=<line_number> \
     -f side="RIGHT"
   ```

2. **Multi-line comment** - Use `start_line` and `line` parameters:
   ```bash
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments \
     --method POST \
     -f body="<comment>" \
     -f path="<file_path>" \
     -f commit_id="$(git rev-parse HEAD)" \
     -F start_line=<start> \
     -F line=<end> \
     -f side="RIGHT"
   ```

3. **Include context** - In your comment body, include the relevant code snippet using markdown code blocks.

4. **Link to the PR** - After posting comments, provide the PR URL: `gh pr view --web`

## Execution Rules

- **MANDATORY**: Get user approval before posting any comments to GitHub
- Be constructive, not critical - suggest improvements rather than just pointing out problems
- Group related issues when possible
- Prioritize actionable feedback over style nitpicks
