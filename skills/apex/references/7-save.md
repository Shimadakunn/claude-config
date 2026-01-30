# Save Phase

Commit changes, push to remote, and create PR.

## Git Workflow

### 1. Stage Changes
```bash
git status  # Review changes
git add <specific files>  # Stage relevant files only
```

Avoid `git add -A` - be explicit about what's committed.

### 2. Commit
Create a descriptive commit message:
```bash
git commit -m "$(cat <<'EOF'
<type>: <short description>

<optional body explaining why>
EOF
)"
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

### 3. Push
```bash
git push -u origin <branch>
```

### 4. Create PR (if none exists)

Check for existing PR:
```bash
gh pr list --head $(git branch --show-current)
```

Create PR if needed:
```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
- <bullet points>

## Test plan
- [ ] <testing steps>

EOF
)"
```

## Using Save Subagent

Alternatively, spawn the save subagent:

```
Task (subagent_type: save):
Commit, push, and create PR for the changes.
Summary: <brief description of changes>
```

## PR Guidelines

- Title: Short, imperative (e.g., "Add user authentication")
- Summary: Bullet points of key changes
- Test plan: How to verify the changes work
- Keep PR focused on single feature/fix
