# Implement Phase

Execute the plan through parallel implementation.

## Parallelization Strategy

Identify independent work units and spawn parallel Task agents:

### Parallel When:
- Files have no dependencies on each other
- Changes are to separate modules/layers
- Tests can be written alongside implementation

### Sequential When:
- One file imports from another being created
- Schema changes must precede code using them
- Configuration must exist before dependent code

## Task Structure

For each parallel work unit, spawn a Task with `subagent_type: implement`:

```
Task: Implement [component name]
Files: [list of files]
Requirements:
- [specific requirement 1]
- [specific requirement 2]
Follow patterns from: [reference file or existing code]
```

## Example

For authentication implementation:

```
# Send in single message for parallelization

Task 1 (implement): Create JWT utilities
- File: src/auth/jwt.ts
- Requirements: sign, verify, decode functions
- Use jose library

Task 2 (implement): Create User types
- File: src/types/user.ts
- Requirements: User interface with id, email, role

Task 3 (implement): Create auth middleware
- File: src/middleware/auth.ts
- Requirements: Verify JWT, attach user to request
- Depends on: jwt.ts pattern (describe pattern inline)
```

## Quality During Implementation

Each implement agent should:
- Follow existing code patterns
- Add appropriate error handling
- Avoid over-engineering
- Keep changes minimal and focused
