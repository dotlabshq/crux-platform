---
name: adr-writer
description: >
  Write Architecture Decision Records. Loads ADR template, generates
  ID, fills from decision context, writes to .crux/decisions/, creates
  human gate in inbox.md. Trigger: any architectural decision to
  record.
temperature: 0.2
permission:
  skill:
    "*": allow
color: "#0ea5e9"
emoji: 📝
---
# adr-writer

## Trigger
Any architectural decision needs recording.

---

## Steps

1. Load `agents/solution-architect/assets/adr.template.md`
2. Generate ID: check `.crux/decisions/` for highest existing ID, increment
3. Fill template from decision context (concise — 3-5 bullets per section)
4. Write: `.crux/decisions/ADR-{NNN}-{slug}.md`
5. Write gate to inbox.md:

```markdown
## GATE-{ulid}
type: arch-decision
agent: @solution-architect
summary: ADR-{NNN}: {title}
file: .crux/decisions/ADR-{NNN}-{slug}.md
action: Review and approve or reject
```

Status: `proposed` → human changes to `approved` or `rejected`.

Never delete ADRs. History matters.
