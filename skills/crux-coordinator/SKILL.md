---
name: crux-coordinator
description: >
  Boot protocol skill. Reads at every session start. Checks workspace
  state, loads base context, resumes pending work, routes incoming
  requests. Trigger: session start.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#7c3aed"
emoji: 🧭
---
# crux-coordinator

## Trigger

Read this skill at every session start. It is the boot protocol.

---

## Boot Sequence

### 1 — Workspace State Check

Read `.crux/workspace/MANIFEST.md`.

```
Missing or status: pending-onboard  → run platform-init workflow
status: partial-onboard             → resume onboarding from last step
status: onboarded                   → normal operation
```

### 2 — Context Load

Load base context (always, ~3000 tokens):
```
.crux/CONSTITUTION.md
.crux/SOUL.md
{framework-home}/agents/coordinator/AGENT.md
.crux/workspace/MEMORY.md
.crux/workspace/TODO.md
```

Hard limit: 8000 tokens before execution begins. Load other files only on demand.

### 3 — Pending Work Check

Read `.crux/workspace/TODO.md`. Any `open` tasks from previous session → resume before starting new work.

Read `.crux/workspace/inbox.md`. Any `waiting` human gates → surface to human before proceeding.

### 4 — Route Incoming Request

See `{framework-home}/agents/coordinator/AGENT.md` for full routing table.

Short version:
- Feature request → capability-check skill first, always
- Architecture question → @solution-architect
- Security concern → @security-lead or @ciso-advisor
- Database admin → @postgresql-admin or @mysql-admin
- Production incident → incident-triage skill immediately
- Infra/deploy → @platform-engineer

---

## Skill Loading

Skills are loaded on trigger and unloaded after use. Never keep a skill in context between tasks.

```
trigger phrase detected → load skills/{name}/SKILL.md → execute → unload
```

## Agent Loading

Agent AGENT.md files are loaded only when delegating to that agent. Not before.

For 30B models: load one agent at a time. Sequential delegation only.

---

## Session End

Before ending any session:
- Update `.crux/workspace/TODO.md` — mark completed tasks `done`, blocked tasks `blocked`
- Write any new facts to `.crux/workspace/MEMORY.md`
- If work triggered registry changes, write to `$HOME/.crux/registry/`
