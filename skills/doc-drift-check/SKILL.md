---
name: doc-drift-check
description: >
  Check if documentation was updated alongside source code changes.
  Advisory only — never blocks merge. Trigger: after any merge to main.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#ca8a04"
emoji: 📄
---
# doc-drift-check

## Trigger
After any merge to main.

---

## Steps

1. `git diff --name-only HEAD~1 HEAD` — get changed source files
2. For each public-facing source file (routes, handlers, SDK, schema): check if docs/ equivalent was also updated
3. Flag stale/missing docs as advisory

## Output
```markdown
## Doc Drift Check
Stale (not updated in this merge):
  - {source} → {expected doc}
Missing docs:
  - {source} → no doc found
```

Advisory only. Never blocks merge.
