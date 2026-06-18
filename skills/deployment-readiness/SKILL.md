---
name: deployment-readiness
description: >
  Pre-production deployment checklist: tests, coverage, security,
  changelog, rollback plan, staging. Always creates human gate for
  production. Trigger: before any production deployment.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#ea580c"
emoji: ✅
---
# deployment-readiness

## Trigger
Before any production deployment.

---

## Checklist

### Code Quality
- [ ] All tests pass (CI green)
- [ ] Coverage meets threshold (CONSTITUTION.md, default 70%)
- [ ] No open FAIL items from tenant-isolation-audit
- [ ] No unresolved critical/high security findings

### Documentation
- [ ] Changelog updated
- [ ] API changes in OpenAPI spec
- [ ] Migration guide exists if breaking change

### SDK/Dependency
- [ ] SDK consumers notified if breaking change
- [ ] No critical CVE in dependencies

### Deployment
- [ ] Rollback plan documented or automated
- [ ] DB migrations are reversible (or irreversibility approved)
- [ ] Staging deployment succeeded
- [ ] Monitoring for new endpoints

---

## Output
```markdown
## Deployment Readiness: {version}
Result: APPROVED | BLOCKED

Failures (blocking):
  - [ ] {check}: {issue}

Warnings:
  - [ ] {check}: {concern}
```

## Human Gate (always required for production)
```markdown
## GATE-{ulid}
type: deploy
agent: @platform-engineer
summary: Ready to deploy {version} to production
readiness: APPROVED|APPROVED_WITH_WARNINGS
```
