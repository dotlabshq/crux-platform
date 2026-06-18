---
name: tenant-isolation-audit
description: >
  Audit database schema, query layer, and route handlers for tenant
  isolation (org_id/tenant_id). Failures block merge. SAAS/ALL
  deployment mode only. Trigger: schema change, new route handler, new
  query layer.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#dc2626"
emoji: 🔒
---
# tenant-isolation-audit

## Trigger
Schema change, new route handler, new query layer, PR review — in SAAS/ALL mode only.

---

## Checks

### Schema
Every new tenant-owned table must have `tenant_id`/`org_id`, NOT NULL.
Exceptions: users (via memberships), system_config, audit_logs.

### Query Layer
Every SELECT/UPDATE/DELETE must include tenant_id WHERE clause. Not optional.

```typescript
// FAIL
db.select().from(projects)
// PASS
db.select().from(projects).where(eq(projects.orgId, orgId))
```

### Routes
- org context from auth middleware, never from request body
- tenant context passed to query layer

### Cross-Tenant
- No resource fetch by ID without tenant membership check
- No admin endpoints without explicit role check

---

## Output
```markdown
## Tenant Isolation Audit
Result: PASS | FAIL | WARNINGS

Failures (block merge):
  - {file}:{line}: {description}

Passed: {n} tables · {n} queries · {n} routes
```

On FAIL: write blocking GATE to inbox.md.
