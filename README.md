# Crux Platform

Markdown-native, multi-agent platform engineering framework. Define agents, skills, and workflows as plain `.md` files — no runtime required.

---

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/dotlabshq/crux-platform/main/scripts/install.sh | bash
```

Then start your AI tool in the project directory. The coordinator runs workspace initialization automatically.

## What's Included

**New Platform Agents:**
- `@coordinator` — single entry point, routes all work, enforces capability-first principle
- `@solution-architect` — technology decisions, shared app evaluation, ADR authoring
- `@platform-steward` — SDK versioning, breaking change management, interface sync
- `@spectator` — cross-project duplicate detection, version drift, weekly scan

**Full Development Team:**
- `@backend-developer`, `@frontend-developer`, `@platform-engineer`
- `@security-lead`, `@ciso-advisor`, `@red-team-lead`
- `@postgresql-admin`, `@kubernetes-admin`, `@linux-admin`
- Plus 20+ specialized agents for finance, advisory, operations

**Platform Skills:**
- `platform-init` — project onboarding with auto-discovery
- `capability-check` — before any new feature, check if it already exists
- `shared-app-decision` — evaluate whether capability should be L2 shared app
- `deployment-readiness` — production deploy checklist
- `tenant-isolation-audit` — multi-tenant security enforcement
- `incident-triage` — P0-P3 incident classification and response
- And more...

## Cross-Project Registry

`$HOME/.crux/registry/` tracks all your projects and their capabilities. The coordinator checks this before building anything — preventing duplicate implementations across repos.

## 30B Model Compatible

Agents are written for efficient token usage. Coordinator routes one agent at a time for smaller context windows.

## Directory Layout

```
$HOME/.crux/           framework home (installed here)
├── agents/            agent definitions
├── skills/            skill protocols
├── templates/         starter templates
├── workflows/         workflow definitions
├── registry/          cross-project awareness
└── scripts/           install, convert, update

{project}/
├── AGENTS.md          bootstrap — AI tools read this first
└── .crux/
    ├── CONSTITUTION.md
    ├── SOUL.md
    ├── docs/
    ├── decisions/
    ├── summaries/
    └── workspace/     gitignored — local state only
```

## Git Policy

```
.crux/workspace/   → gitignored (local only)
.crux/             → everything else committed
$HOME/.crux/registry/ → machine-local, not in git
```
