# Resolve Phase

Address review findings systematically.

## Prioritization

Fix issues in severity order:

1. **Critical** (Security): Fix immediately, all security issues
2. **High** (Correctness): Fix logic errors, broken functionality
3. **Medium** (Performance): Fix inefficiencies, resource issues
4. **Low** (Maintainability): Fix if time permits, or note for future

## Parallelization Strategy

Group independent fixes and resolve in parallel:

```
Task 1 (implement): Fix security issues
- Issue: SQL injection in user query
- Issue: Missing input sanitization
Files: [affected files]

Task 2 (implement): Fix correctness issues
- Issue: Off-by-one error in pagination
- Issue: Missing null check
Files: [affected files]

Task 3 (implement): Fix performance issues
- Issue: N+1 query in user list
- Issue: Unnecessary re-renders
Files: [affected files]
```

## Resolution Guidelines

- Fix the specific issue, avoid scope creep
- Maintain existing patterns
- Add tests for bugs fixed
- Document non-obvious fixes with brief comments

## Verification

After resolving:
1. Re-run affected tests
2. Spot-check critical fixes
3. Confirm no regressions

If new issues arise during resolution, log them but complete current fixes first.

## Skip Conditions

- Skip resolution if review found no issues
- Skip low-priority issues if explicitly deprioritized by user
