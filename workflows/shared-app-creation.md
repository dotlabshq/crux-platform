# Workflow: shared-app-creation

## Trigger
shared-app-decision returns BUILD_SHARED and human approves.

---

## Steps

1. ADR (@solution-architect + adr-writer) — human gate before proceeding
2. Repo/package creation (@platform-engineer) — add AGENTS.md
3. Crux init (arc runs platform-init workflow on new app)
4. Interface design (@solution-architect + @backend-developer) — REST + SDK + MCP contracts
5. Implementation (@backend-developer) — contract-first
6. SDK package (@backend-developer + @platform-steward) — initial v1.0.0
7. MCP server (@backend-developer) — wrap SDK
8. Registry update (arc) — capabilities.md + sdk-versions.md
9. First consumer integration

## Completion
REST+SDK+MCP implemented · registered in registry · original project integrated
