# Arc Onboarding

## Purpose
Run when MANIFEST.md missing or status: pending-onboard. One question at a time. Show defaults in brackets.

---

## Step 1 — Silent Discovery

Scan before speaking:

```
README.md                    → name, description
package.json/pyproject.toml  → name, stack, version
go.mod / Cargo.toml          → stack

Deployment model (determine, do not ask):
  wrangler.toml    → SAAS
  fly.toml         → SAAS
  docker-compose.yml (no k8s/) → SELF_HOSTED
  k8s/ or helm/    → ON_PREM
  Dockerfile only  → default SAAS (note in SOUL.md)
  multiple signals → ALL

Code exists: src/ or app/ present?
Partial onboarding: .crux/CONSTITUTION.md exists?
```

## Step 2 — Registry Check (silent)

Load `$HOME/.crux/registry/capabilities.md`. Note what's already in ecosystem.

## Step 3 — Project Identity (ask only if README uninformative)

```
What does this project do? (one sentence)
```

## Step 4 — Development Approach

```
How should agents write code here?
  [1] Contract-first + test-as-checkpoint  ← default
  [2] TDD (test-first)
  [3] Prototype-first
  [4] Freestyle
Enter to accept [1]:
```

## Step 5 — Human Loop

```
How often should agents pause for review?
  [1] Minimal — 3 critical gates  ← default
  [2] Standard — gates + AI PR review
  [3] High — gates + every decision
Enter to accept [1]:
```

---

## Writes

```
.crux/CONSTITUTION.md   coding approach, human loop, tenant rule, confidence threshold 0.6
.crux/SOUL.md           name, description, stack, deployment model (from discovery)
.crux/docs/project-overview.md
.crux/docs/platform-layers.md
.crux/docs/capability-map.md    local + inherited from registry
.crux/docs/deployment-model.md  from discovery, not asked
.crux/workspace/MANIFEST.md     status: onboarded
.crux/workspace/TODO.md · MEMORY.md · inbox.md
.crux/workspace/{role}/         per active agent

$HOME/.crux/registry/projects/{slug}.md
$HOME/.crux/registry/projects.md         append
$HOME/.crux/registry/capabilities.md     merge
```

Ensure `.crux/workspace/` is in `.gitignore`.

---

## First Suggestion

```
Ready. Best next step I see:
A) {specific gap from codebase scan}
B) {alternative}
What would you like to work on?
```
