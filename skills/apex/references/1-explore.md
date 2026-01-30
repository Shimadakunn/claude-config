# Explore Phase

Gather context by spawning parallel `explore` agents for codebase, documentation, and web research.

## Task Tracking

```
TaskUpdate(taskId: "explore", status: "in_progress")
```

## Process

### 1. Analyze What's Needed

From the feature and user request, determine which explorations to run:

| Source | Spawn When | Skip When |
|--------|------------|-----------|
| **Codebase** | Modifying existing code, need patterns | Greenfield project |
| **Documentation** | Using external libraries/APIs | No external deps |
| **Web Research** | Best practices, new tech | Purely internal task |

### 2. Spawn Parallel Agents

Launch all needed agents in a **single message**:

#### Codebase Agent
```
Task(subagent_type=explore, description="Codebase exploration"):
"EXPLORATION TYPE: Codebase

FEATURE: [feature description]

Find:
- Related files and their purposes
- Patterns and conventions used
- Dependencies and imports
- Potential integration points

Output file:line references for key discoveries."
```

#### Documentation Agent
```
Task(subagent_type=explore, description="Documentation lookup"):
"EXPLORATION TYPE: Documentation

LIBRARIES: [library names from user request]
FEATURE: [what we need from docs]

Use Context7 MCP to query:
- API methods needed
- Usage patterns and examples
- Configuration options
- Known limitations

Output code snippets where helpful."
```

#### Web Research Agent
```
Task(subagent_type=explore, description="Web research"):
"EXPLORATION TYPE: Web Research

TOPICS: [topics relevant to feature]

Use Exa MCP to find:
- Current best practices (2025+)
- Common pitfalls to avoid
- Performance considerations
- Security recommendations

Output source URLs for findings."
```

### 3. Synthesize Findings

After all agents complete, combine into actionable context:

- **Relevant files**: List with file:line and purpose
- **Patterns to follow**: Conventions from the codebase
- **API usage**: Key methods and examples from docs
- **Best practices**: Recommendations from research
- **Risks**: Potential issues and mitigations

## Completion

```
TaskUpdate(taskId: "explore", status: "completed")
```

## Skip When

- Trivial change with known context
- User explicitly provides all needed context
- Greenfield project with no external dependencies

If skipping: `TaskUpdate(taskId: "explore", status: "completed", description: "Skipped: [reason]")`
