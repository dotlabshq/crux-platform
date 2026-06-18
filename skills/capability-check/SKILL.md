---
name: capability-check
description: >
  Before any new feature: check if capability already exists locally or
  in $HOME/.crux/registry/. Returns LOCAL_MATCH, REGISTRY_MATCH,
  PARTIAL, MISSING_LOCAL, or MISSING_SHARED. Trigger: any new feature
  request.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#0ea5e9"
emoji: 🔍
---
# capability-check

## Trigger
Before any new feature request. No exceptions.

---

## Steps

### 1 — Load Sources
```
1. .crux/docs/capability-map.md          (local)
2. $HOME/.crux/registry/capabilities.md  (global)
3. Scan codebase if local map missing
```

### 2 — Scan Keywords (if needed)
```
auth:    auth/, lib/auth, login, jwt, oidc, oauth, session
org:     org/, organization/, tenant_id, workspace, member
billing: billing/, stripe/, subscription, invoice, plan
notif:   email/, notification/, webhook/, template/
flags:   flag/, feature-flag/, feature_flags
config:  config/, secrets/, vault/
```

### 3 — Match and Return Result

**LOCAL_MATCH** — exists in this project
→ Route to owning code. Do not create new implementation.

**REGISTRY_MATCH** — exists in another registered project
→ Import SDK or call API. Source: {project}. Do not rebuild.

**PARTIAL** — partial implementation exists
→ Extend existing. Route to owning agent.

**MISSING_LOCAL** — not found, single project need
→ Build locally. @spectator monitors.

**MISSING_SHARED** — commodity capability, multi-project
→ Trigger shared-app-decision skill.

---

## Output
```
capability: {noun}
result: {LOCAL_MATCH|REGISTRY_MATCH|PARTIAL|MISSING_LOCAL|MISSING_SHARED}
location: {path or null}
available-as: {SDK if registry match}
action: {next step}
confidence: {0.0-1.0}
```
Confidence < 0.7 → human review before proceeding.
