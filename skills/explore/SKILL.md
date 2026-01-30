---
name: explore
description: Explore the codebase, documentation, and web to gather context for implementation.
disable-model-invocation: true
user-invocable: false
---

# Detection

Detect if need to explore the codebase, documentation, or web.

- **Codebase**: code, architecture, symbols, project structure → `explore-codebase` subagent
- **Docs**: library, framework, API, SDK mentioned → `explore-doc` subagent
- **Web**: URL provided, or need web search → `explore-web` subagent

# Execute

Spawn ALL detected agents in parallel.
