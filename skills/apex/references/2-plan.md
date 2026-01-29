# Step 2: Plan

Design implementation approach based on exploration.

## Create Plan

Break task into subtasks with:
- Description and acceptance criteria
- Files to modify
- Dependencies (which subtasks must complete first)

Example:
```
Subtask 1: Create database schema
  - Files: db/migrations/*, app/models/user.rb
  - Dependencies: none

Subtask 2: Implement API endpoints
  - Files: app/controllers/api/v1/users_controller.rb
  - Dependencies: Subtask 1

Subtask 3: Add frontend components
  - Files: app/javascript/components/*
  - Dependencies: Subtask 2
```

## Approval

- `-np` flag: auto-approve
- Otherwise: ask user to approve, modify, or abort

## Next

Read: `~/.claude/skills/apex/references/3-implement.md`
