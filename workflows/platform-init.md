# Workflow: platform-init

## Trigger
MANIFEST.md missing or status: pending-onboard. "crux init".

---

## Steps

1. Discovery (silent) — README, package files, deployment indicators, existing code
2. Registry lookup — load global capabilities
3. Onboarding conversation (max 3 questions, defaults shown)
4. Capability scan (if code exists)
5. Write all `.crux/` foundation files
6. Update .gitignore
7. Register in `$HOME/.crux/registry/`
8. Present first suggestion

## Completion
MANIFEST.md status: onboarded · all .crux/ files written · registered in registry · .gitignore updated
