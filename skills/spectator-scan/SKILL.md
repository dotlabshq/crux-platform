---
name: spectator-scan
description: >
  Full or incremental scan across registered projects. Detects
  duplicate implementations, version drift, tenant gaps, dead code, doc
  drift. Advisory output only — never blocks. Trigger: weekly,
  post-merge, on demand.
temperature: 0.1
permission:
  skill:
    "spectator-scan": allow
color: "#64748b"
emoji: 🔭
---
# spectator-scan

## Trigger
Weekly (full), post-merge (incremental), "run spectator scan".

---

## Full Scan

### 1 — Load Registry
`$HOME/.crux/registry/projects.md` + `capabilities.md` + `sdk-versions.md`

### 2 — Cross-Project Duplicates
For each active project: search src/ for capability keywords.
Flag: same capability as local in 2+ projects. Severity: 2→warning, 3+→action-needed.

Keywords: auth/login/jwt · tenant_id/org_id · subscription/invoice · sendEmail/webhook · getSecret/vault

### 3 — Version Drift
Compare SDK imports vs registry current.
1 major behind → info. 2 major → warning. 3+ → action-needed.

### 4 — Tenant Gaps (SAAS only)
Light scan: queries without tenant_id filter in recent changes.

### 5 — Dead Code
Files unchanged 90+ days, zero imports. Flag as info.

### 6 — Doc Drift
Files changed in last merge without docs update. Flag as info.

### 7 — Registry Refresh
Update each scanned project's registry entries.

---

## Output (advisory only)
```markdown
## SPECTATOR-{ulid}
type: advisory
severity: info|warning|action-needed
category: {duplicate-code|version-drift|tenant-gap|dead-code|doc-drift}
found-in: [{path}]
summary: {one line}
recommendation: {what should happen}
effort: low|medium|high
```
