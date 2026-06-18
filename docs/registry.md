# Crux Registry

`$HOME/.crux/registry/` — cross-project awareness. Plain markdown. No server.

---

## Structure

```
$HOME/.crux/registry/
├── projects.md          all registered projects
├── capabilities.md      global capability map
├── sdk-versions.md      SDK consumption per project
└── projects/
    └── {slug}.md        per-project detail card
```

## projects.md
```markdown
| Slug | Name | Path | Type | Status | Registered |
|---|---|---|---|---|---|
| my-saas | My SaaS | /Users/ali/projects/my-saas | monorepo | active | 2025-01 |
```
Type: monorepo|standalone|sdk|lib|infra

## capabilities.md
```markdown
## Authentication
| Implementation | Project | Location | Type | Maturity |
|---|---|---|---|---|
| OIDC/Zitadel | my-saas | packages/lib/auth | lib | stable |
```
Maturity: wip|stable|deprecated

## sdk-versions.md
```markdown
## @org/billing-sdk
current: v2.1.0
| Consumer | Version | Status |
|---|---|---|
| my-saas | v2.0.1 | ok |
```

## projects/{slug}.md
```markdown
# {Project Name}
Path/Type/Deployment/Stack/Status
## Capabilities Provided / SDKs Provided / SDKs Consumed / Agents Active
```

---

## Update Rules

At crux init: platform-init writes entry + merges capabilities
When capability changes: owning agent updates local map + registry
Weekly: @spectator re-scans and refreshes

---

## Git

$HOME/.crux/registry/  → NOT in any project's git (machine-local)
{project}/.crux/       → IN git (everything except workspace/)
{project}/.crux/workspace/ → GITIGNORED

## Team Registry (optional)

```bash
export CRUX_REGISTRY="/shared/path"
# or
export CRUX_REGISTRY="https://raw.githubusercontent.com/org/registry/main"
```
URL: agents read-only.
