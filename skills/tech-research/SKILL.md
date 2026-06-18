---
name: tech-research
description: >
  Structured technology comparison before architectural decision.
  Produces comparison table and recommendation with confidence score
  (0-1). Trigger: technology comparison needed.
temperature: 0.3
permission:
  skill:
    "*": allow
color: "#0ea5e9"
emoji: 🔬
---
# tech-research

## Trigger
Technology comparison needed before architectural decision.

---

## Steps

### 1 — Constraints
Extract: team familiarity, existing stack, deployment model, scale, reversibility.

### 2 — Research Each Option
For each: maturity, fit, integration effort, cost at scale, self-hosted complexity, vendor lock-in risk.

### 3 — Comparison Table
```markdown
| Criterion | {A} | {B} | {C} |
|---|---|---|---|
| Maturity | | | |
| Stack fit | | | |
| Integration effort | | | |
| Cost at scale | | | |
| Self-hosted | | | |
| Lock-in risk | | | |
| Our experience | | | |
```

### 4 — Recommendation
```
Confidence: {0.0-1.0}
Recommend: {option}
Why: {primary + secondary reason}
Trade-off accepted: {what we give up}
Revisit if: {condition}
```

Confidence scoring:
- ≥0.8 → clear winner, write ADR
- 0.6-0.8 → good option, note uncertainties
- 0.5-0.6 → present two options, do not recommend
- <0.5 → state what's missing, ask human
