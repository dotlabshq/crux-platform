---
name: platform-init
description: >
  Project workspace initialization. Runs environment discovery,
  onboarding conversation (max 3 questions), capability scan, writes
  all .crux/ foundation files, registers in global registry. Trigger:
  MANIFEST.md missing or pending-onboard.
temperature: 0.2
permission:
  skill:
    "*": allow
color: "#7c3aed"
emoji: 🚀
---
# platform-init

## Trigger
MANIFEST.md missing or status: pending-onboard. Also: "crux init", "initialize workspace".
Runs once. Sets status: onboarded when complete.

---

## Steps

### 1 — Discovery (silent)
```
README.md → name, description
package.json/pyproject.toml/go.mod → stack
Deployment model (do not ask):
  wrangler.toml    → SAAS
  fly.toml         → SAAS
  docker-compose.yml (no k8s/) → SELF_HOSTED
  k8s/ or helm/    → ON_PREM
  Dockerfile only  → SAAS default
  multiple         → ALL
src/ or app/ → has code
.crux/CONSTITUTION.md exists → partial onboarding, resume
```

### 2 — Registry Lookup
Load `$HOME/.crux/registry/capabilities.md`. Note ecosystem capabilities.

### 3 — Onboarding Conversation (max 3 questions)
- Project identity (skip if README informative)
- Development approach [default: contract-first]
- Human loop [default: minimal]
Deployment model NOT asked.

### 4 — Capability Scan
If code exists: scan src/ for existing capabilities. Map to L0-L3.
Mark registry capabilities as `inherited` in local map.

### 5 — Write Foundation Files
```
.crux/CONSTITUTION.md   coding approach, human loop, tenant rule, confidence threshold 0.6
.crux/SOUL.md           name, description, stack, deployment model
.crux/docs/project-overview.md
.crux/docs/platform-layers.md
.crux/docs/capability-map.md
.crux/docs/deployment-model.md
.crux/workspace/MANIFEST.md    status: onboarded
.crux/workspace/TODO.md · MEMORY.md · inbox.md
.crux/workspace/{role}/        per active agent
```

### 6 — .gitignore
Add `.crux/workspace/` if missing. All other `.crux/` is committed.

### 7 — Registry Registration
```
Write:  $HOME/.crux/registry/projects/{slug}.md
Append: $HOME/.crux/registry/projects.md
Merge:  $HOME/.crux/registry/capabilities.md
```

### 8 — First Suggestion
Present 2 prioritized next steps based on gaps found.

---

## Error Handling
- Discovery fails → safe defaults, mark unknowns as `# TODO`
- Registry write fails → continue, retry next session
- User abandons → status: partial-onboard, resume next session
