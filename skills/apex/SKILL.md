---
name: apex
description: Systematic implementation using APEX methodology (Analyze-Plan-Execute-eXamine). Use when implementing features, fixing bugs, or making code changes. Triggers on requests like "implement feature", "build", "create", "add functionality", or when user invokes /apex.
---

# APEX Workflow

Structured implementation: explore → plan → implement → test → review → resolve → save.

## Architecture

**Skill = Workflow** (orchestration, sequencing, coordination)
**Agents = Brain** (detailed instructions, model selection, behavior)

Agents are defined in `~/.claude/agents/`:
```
agents/
├── explore.md          # Exploration orchestrator
├── implement.md        # Implementation with critical analysis
├── test.md             # Automated/manual testing
├── save.md             # Git operations with user confirmation
└── review/
    ├── correctness.md  # Logic, edge cases, error handling
    ├── security.md     # OWASP vulnerabilities
    ├── performance.md  # Complexity, resources, caching
    └── maintainability.md  # Clarity, consistency, patterns
```

### Loading Agents

Each workflow step reads its agent file and injects instructions into the Task prompt:

1. Read agent file (e.g., `~/.claude/agents/implement.md`)
2. Parse YAML frontmatter for `model` (opus/haiku/sonnet)
3. Extract markdown body as `instructions`
4. Pass to Task: `Task({ model, prompt: instructions + context })`

## Flags

| Flag | Effect |
|------|--------|
| `-help` | Show usage |
| `-doc` | Force docs exploration |
| `-web` | Force web exploration |
| `-nc` | Skip codebase exploration |
| `-np` | Auto-approve plan |
| `-at` | Automated testing |
| `-st` | Skip testing |
| `-resume` | Resume from last state |

## Start

Read and execute: `~/.claude/skills/apex/references/0-init.md`
