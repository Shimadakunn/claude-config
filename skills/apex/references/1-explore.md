# Explore Phase

Gather comprehensive context through parallel exploration.

## Strategy

Launch 3 parallel Task agents in a single message:

```
Task 1: Codebase Exploration (subagent_type: Explore)
- Find files related to the feature area
- Identify existing patterns and conventions
- Map dependencies and integrations
- Note test patterns used

Task 2: Documentation Lookup (subagent_type: general-purpose)
- Use Context7 MCP to query relevant library docs
- Focus on APIs and patterns needed for implementation

Task 3: Web Research (subagent_type: general-purpose)
- Use Exa MCP for technical research
- Search for best practices, common pitfalls
- Find similar implementations for reference
```

## Consolidation

After all agents complete, synthesize findings:

1. **Relevant files**: List files to read/modify with their purpose
2. **Patterns**: Document conventions to follow
3. **Dependencies**: Note libraries and their APIs
4. **Risks**: Flag potential issues discovered

## Example

For "add user authentication":

```
Agent 1 (Explore): Search for existing auth code, user models, middleware patterns
Agent 2 (Context7): Query JWT library docs, session management
Agent 3 (Exa): Research "secure authentication patterns Node.js 2025"
```

## Skip Conditions

- Skip web research if the task is purely internal/codebase-specific
- Skip docs lookup if no external libraries are involved
- Skip codebase exploration only for greenfield projects
