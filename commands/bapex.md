---
description: Systematic implementation using BAPEX methodology (Brainstorm-Analyze-Plan-Execute-eXamine)
---

<objective>
Implement #$ARGUMENTS using the systematic BAPEX workflow to ensure product clarity, thorough analysis, detailed planning, clean execution, and proper verification.

This methodology helps developers deliver high-quality features by breaking complex tasks into five distinct phases: Brainstorm (explore & scope), Analyze (gather context), Plan (create strategy), Execute (implement), and eXamine (verify).
</objective>

<context>
Current git status: !`git status 2>/dev/null || echo "Not a git repository"`
Current branch: !`git branch --show-current 2>/dev/null || echo "Not a git branch"`
</context>

<process>

## Phase 0: BRAINSTORM

**Goal**: Deep collaborative exploration to fully understand the idea before any technical work

This phase is **iterative** - engage in multiple rounds of back-and-forth with the user until complete clarity is achieved.

### Round 1: Initial Understanding

Use `AskUserQuestion` tool to ask:

1. **The "Why"**: What triggered this idea? What's the frustration or opportunity?
2. **The "Who"**: Who will use this? In what context?
3. **The "What"**: In your own words, what should this do?

Listen carefully to responses. Take notes on ambiguities and assumptions.

### Round 2: Deep Dive

Based on Round 1 answers, use `AskUserQuestion` tool to probe deeper:

1. **Challenge assumptions**: "You mentioned X - have you considered Y instead?"
2. **Explore alternatives**: "What if we approached it as Z? Would that solve the same problem?"
3. **Uncover hidden needs**: "When you say [user's words], do you mean A or B?"
4. **Find the real problem**: Often the first request hides a deeper need - dig for it

Keep using `AskUserQuestion` until you can explain the idea back to the user better than they explained it to you.

### Round 3: Scope Negotiation

Present your understanding and negotiate scope:

1. **Summarize your understanding**: Explain back what you think they want
2. **Propose MVP**: "The simplest version that delivers value would be..."
3. **Identify trade-offs**: "We could do X or Y, but not both in MVP. Which matters more?"
4. **Define anti-scope**: "To keep this focused, we're explicitly NOT doing..."

Use `AskUserQuestion` to get explicit agreement on each point.

### Round 4: Edge Cases & Scenarios

Use `AskUserQuestion` tool to walk through concrete scenarios:

1. **Happy path**: "User opens the app, does X, sees Y - correct?"
2. **Edge cases**: "What happens when...?" (empty states, errors, limits)
3. **Integration points**: "How does this interact with existing features?"

### Brainstorm Completion Checklist

Use `AskUserQuestion` tool to get explicit user confirmation on each item:

- [ ] Problem statement (1-2 sentences) - user agrees this is THE problem
- [ ] Core value proposition - user confirms this is what makes it valuable
- [ ] MVP feature list (prioritized) - user ranked these explicitly
- [ ] Out-of-scope items - user agreed these are NOT in MVP
- [ ] Key user flows - user validated the step-by-step journeys
- [ ] Success criteria - user defined what "done" looks like

**Output clear heading**: `# 0. BRAINSTORM`

**CRITICAL**: Use `AskUserQuestion` tool to get final approval. Do NOT proceed until user explicitly confirms: "Yes, you understand what I want to build."

If at any point you're unsure, use `AskUserQuestion` to ask another question. It's better to ask 10 questions now than to build the wrong thing.

---

## Phase 1: ANALYZE

**Goal**: Find all relevant files and context for implementation

1. **Think deeply** before launching agents - know exactly what to search for
2. Launch **parallel subagents** to gather context:
   - `explore-codebase` agent to search codebase for relevant patterns
   - `websearch` agent to gather online information if needed
   - `explore-docs` agent to search documentation for API usage
3. Find files to use as **examples** or **edit targets**
4. Identify relevant file paths and useful context

**Output clear heading**: `# 1. ANALYZE`

## Phase 2: PLAN

**Goal**: Create detailed implementation strategy

1. Write comprehensive implementation plan including:
   - Core functionality changes
   - Test coverage requirements
   - Lookbook components if needed
   - Documentation updates
2. **STOP and ASK** user if anything remains unclear using `AskUserQuestion` tool
3. Get user approval before proceeding to execution

**Output clear heading**: `# 2. PLAN`

## Phase 3: EXECUTE

**Goal**: Implement following existing patterns

1. Follow existing codebase style:
   - Prefer clear variable/method names over comments
   - Match existing patterns and conventions
2. **CRITICAL RULES**:
   - Stay **STRICTLY IN SCOPE** - change only what's needed (refer back to Phase 0 scope)
   - NO comments unless absolutely necessary
   - Run autoformatting scripts when done
   - Fix reasonable linter warnings
3. Use parallel execution where possible for speed

**Output clear heading**: `# 3. EXECUTE`

## Phase 4: EXAMINE

**Goal**: Verify changes work correctly

1. **Check package.json** for available scripts (lint, typecheck, test, format, build)
2. Run relevant validation commands:
   - `npm run lint` - Fix any linting issues
   - `npm run typecheck` - Ensure type safety
   - `npm run format` - Format code consistently
3. Run **ONLY tests related to your feature** (stay in scope)
4. For major UX changes:
   - Create test checklist for affected features only
   - Use browser agent to verify specific functionality if needed
5. **Validate against Phase 0**: Does implementation deliver the core value?
6. **If tests fail**: Return to PLAN phase and rethink approach

**Output clear heading**: `# 4. EXAMINE`

</process>

<verification>
Before completing each phase:
- **Brainstorm**: Core value is clear, scope is defined, user confirmed direction
- **Analyze**: Confirmed all relevant files and patterns found
- **Plan**: User has approved the implementation strategy
- **Execute**: Code follows existing patterns, stays in scope, no unnecessary comments
- **Examine**: All validation scripts pass, tests related to changes pass, core value delivered
</verification>

<success_criteria>

- All five phases completed in order with clear headings
- Product vision established before technical work begins
- Deep thinking applied at each phase transition
- Implementation stays strictly within defined scope from Phase 0
- Code passes linting, type checking, and relevant tests
- Follows repository standards for code style and patterns
- No scope creep - only changed what was needed
- Core value proposition is delivered
- Correctness prioritized over speed
  </success_criteria>

<execution_rules>
**Critical principles**:

- **Always ULTRA THINK** before acting
- Product clarity BEFORE technical complexity
- Use parallel execution for speed where possible
- Think deeply at each phase transition
- Never exceed task boundaries defined in Phase 0
- Test ONLY what you changed
- Priority: Correctness > Completeness > Speed
  </execution_rules>
