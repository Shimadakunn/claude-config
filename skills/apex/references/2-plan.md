# Plan Phase

Design a clear implementation approach before writing code.

## Approach

Use `EnterPlanMode` or spawn a Plan subagent to create the implementation design.

## Plan Structure

The plan should cover:

### 1. Changes Overview
- List all files to modify/create
- Describe the purpose of each change

### 2. Implementation Order
- Sequence changes by dependency
- Identify which changes can be parallelized

### 3. Key Decisions
- Technology/pattern choices
- Trade-offs considered
- Rationale for approach

### 4. Risk Assessment
- Breaking changes
- Edge cases to handle
- Testing requirements

## Example Plan

```markdown
## Changes
1. `src/auth/jwt.ts` - Create JWT utility functions
2. `src/middleware/auth.ts` - Add authentication middleware
3. `src/routes/protected.ts` - Apply middleware to routes
4. `src/types/user.ts` - Add User interface

## Order
- Step 1-2 can be parallelized (no dependencies)
- Step 3 depends on Step 2
- Step 4 can run with any step

## Decisions
- Using jose library for JWT (modern, TypeScript-native)
- Middleware pattern matches existing route handlers

## Risks
- Token expiration handling needs edge case testing
- Need to verify compatibility with existing session system
```

## User Approval

Present the plan to the user. Use `ExitPlanMode` or ask for confirmation before proceeding to implementation.
