---
name: architecture-thinking
description: >
  Structured architectural analysis framework: problem definition,
  options, trade-off analysis, recommendation with confidence. Trigger:
  complex architectural question requiring structured analysis.
temperature: 0.3
permission:
  skill:
    "*": allow
color: "#0ea5e9"
emoji: 🏛️
---
# architecture-thinking

## Trigger
Complex architectural question requiring structured analysis.

---

## Framework

### 1 — Problem Definition
What exactly is the problem? What constraints exist? What quality attributes matter most (performance, scalability, maintainability, cost)?

### 2 — Options
Generate 2-4 realistic options. Include the "do nothing" option.

### 3 — Analysis
For each option:
- Fits constraints? (yes/no/partial)
- Quality attributes met?
- Risks and mitigations
- Reversibility (can we change our mind later?)

### 4 — Recommendation
Pick the option that best fits the constraints with the lowest unmitigatable risk. State confidence level (0-1).

### 5 — ADR
If decision is significant: trigger adr-writer skill.

---

## Output
Structured analysis following the framework above. No recommendation without explicit reasoning.
