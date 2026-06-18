# Workflow: new-feature

## Trigger
"add feature", "build", "implement", "we need", "create a"

---

## Steps

### 1 — Capability Check (required, no exceptions)
Agent: coordinator · Skill: `capability-check`
→ LOCAL_MATCH: route to owning code, done
→ REGISTRY_MATCH: import SDK/API, done
→ PARTIAL: route to owning agent to extend, done
→ MISSING_LOCAL: proceed to Step 2
→ MISSING_SHARED: route to @solution-architect, run shared-app-decision

### 2 — Implementation
Agent: @backend-developer + @frontend-developer (parallel, or sequential for 30B)
Approach: per CONSTITUTION.md (default: contract-first)
Contract first → code → tests → tests pass = done

### 3 — Quality Gates
- `tenant-isolation-audit` (SAAS/ALL mode)
- Security check if auth/data-access involved
- `backend-test-writer` / `frontend-test-writer`

### 4 — Documentation
`doc-drift-check` · changelog entry · API spec update

### 5 — Capability Map Update
Owning agent: `.crux/docs/capability-map.md`
Coordinator: `$HOME/.crux/registry/capabilities.md`

## Completion
Tests pass · capability map updated · no open audit failures · PR ready
