---
name: service-request-writer
description: >
  Write service requests from product plane to platform ops plane.
  Creates SR entries with priority P0-P3, type, context, SLA. Trigger:
  schema change needing DBA, new environment, network policy, infra
  provisioning.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#ea580c"
emoji: 📋
---
# service-request-writer

## Trigger
Product plane needs platform ops action: schema change, new environment, network policy, infra.

---

## Steps

1. Classify priority (P0-P3) and type (db-schema/environment/network/infra/security)
2. Write SR to `platform-ops/inbox.md`:

```markdown
## SR-{ulid}
type: {db-schema|environment|network|infra|security}
priority: P{0-3}
requested-by: @{agent}
request: {one-line description}
context: {why needed, what depends on it}
sla: P0: now | P1: today | P2: week | P3: planned
blocking: {what can't proceed}
status: open
created: {timestamp}
```

3. P0/P1: also write GATE to main inbox.md
4. Add `waiting: SR-{ulid}` to requesting agent's TODO

## Return
SR-{ulid} to requesting agent.
