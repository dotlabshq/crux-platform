---
name: sdk-version-check
description: >
  Scan all registered projects for SDK consumption, compare against
  current versions, flag version drift, notify blocked/action-needed
  consumers. Trigger: before any SDK release, version compatibility
  question.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#0d9488"
emoji: 📊
---
# sdk-version-check

## Trigger
Before any SDK/shared app release. "Version compatibility", "who uses this", "breaking change".

---

## Steps

1. Load `$HOME/.crux/registry/sdk-versions.md` and `projects.md`
2. Scan all active projects' package files for SDK imports
3. Compare against current version

```
current   → ok
-1 minor  → ok (info)
-1 major  → warning
-2 major  → action-needed
-3+ major → BLOCKED
```

4. Report and notify action-needed/blocked consumers via their inbox.md
5. Refresh `$HOME/.crux/registry/sdk-versions.md`

## Output
```markdown
## SDK Version Check: {sdk}
Current: {version}  Checked: {timestamp}

| Consumer | Version | Status | Action |
|---|---|---|---|
| {project} | {v} | ok | none |
| {project} | {v} | warning | plan migration |
| {project} | {v} | BLOCKED | immediate |
```
