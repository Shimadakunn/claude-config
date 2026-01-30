# Review Phase

Comprehensive code review through parallel specialized agents.

## Launch 4 Review Agents

Send in a single message to run in parallel:

```
Task 1 (subagent_type: review-correctness):
Review for correctness: logic errors, edge cases, error handling
Files: [list modified files]

Task 2 (subagent_type: review-security):
Review for security: OWASP vulnerabilities, input validation, auth issues
Files: [list modified files]

Task 3 (subagent_type: review-performance):
Review for performance: inefficiencies, resource usage, scalability
Files: [list modified files]

Task 4 (subagent_type: review-maintainability):
Review for maintainability: clarity, consistency, patterns, documentation
Files: [list modified files]
```

## Consolidation Protocol

After all reviews complete:

1. **Collect findings** from each agent
2. **Deduplicate** overlapping issues
3. **Prioritize** by severity:
   - Critical: Security vulnerabilities, data loss risks
   - High: Logic errors, incorrect behavior
   - Medium: Performance issues, missing edge cases
   - Low: Style issues, minor improvements

4. **Present summary** to user before resolving

## Review Focus Areas

### Correctness
- Logic flows correctly
- Edge cases handled
- Errors caught and handled
- Types are correct

### Security
- No injection vulnerabilities
- Input validation present
- Auth/authz implemented correctly
- Secrets not exposed

### Performance
- No unnecessary operations
- Efficient algorithms
- Resources cleaned up
- Caching where appropriate

### Maintainability
- Code is readable
- Follows project conventions
- Appropriate abstraction level
- No code duplication
