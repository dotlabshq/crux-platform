---
name: shared-app-decision
description: >
  Evaluate whether a capability should become a shared app (L2). Scores
  5 criteria 0-2 (max 10). ≥7 build shared, 4-6 build local, ≤3
  integrate off-the-shelf. Trigger: capability-check returns
  MISSING_SHARED.
temperature: 0.2
permission:
  skill:
    "*": allow
color: "#0ea5e9"
emoji: 🏗️
---
# shared-app-decision

## Trigger
capability-check returns MISSING_SHARED, or coordinator asks "should this be a shared app?"

---

## Scoring (0-2 each, max 10)

| Criterion | 0 | 1 | 2 |
|---|---|---|---|
| Cross-project demand | This project only | 1-2 others | 3+ or commodity |
| Commodity nature | Domain-specific | Semi-generic | Generic infra |
| Maintenance justified | Too small | Medium | Complex enough |
| Off-the-shelf fit | Perfect solution exists | Needs customization | No good option |
| Team readiness | No bandwidth | Possible | Ready |

≥7 → BUILD_SHARED. 4-6 → BUILD_LOCAL. ≤3 → INTEGRATE_OFFSHELF.

---

## Output
```markdown
## Shared App Decision: {capability}
Total: {n}/10
Recommendation: {BUILD_SHARED|BUILD_LOCAL|INTEGRATE_OFFSHELF}
Reasoning: {2-3 sentences}

If BUILD_SHARED:
  Name: {app-name}  Layer: L2  Interfaces: REST+SDK+MCP
  ADR required: yes → trigger adr-writer

If BUILD_LOCAL:
  @spectator monitors for: {keywords}

→ Goes to inbox.md for human approval.
```
