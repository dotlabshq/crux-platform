---
name: schema-change-review
description: >
  Review database migration files for safety: reversibility, tenant
  isolation, breaking vs non-breaking changes. Determines if service
  request to DBA is needed. Trigger: any database migration file added
  or modified.
temperature: 0.1
permission:
  skill:
    "*": allow
color: "#1d4ed8"
emoji: 🗄️
---
# schema-change-review

## Trigger
Any database schema change (migration file added or modified).

---

## Checks

### Safety
- [ ] Has both up and down migration
- [ ] No column drops (deprecate instead)
- [ ] No column renames (add new, migrate, deprecate)
- [ ] Adding NOT NULL to existing table has DEFAULT or backfill migration
- [ ] New indexes use CONCURRENTLY (PostgreSQL)

### Tenant Isolation (SAAS)
- [ ] New tenant-owned tables have org_id/tenant_id
- [ ] New tables don't break existing RLS policies

### Breaking vs Non-Breaking
Non-breaking: add nullable column, add table, add index, expand column size
Breaking: drop column, rename, change type, add NOT NULL without default

### Service Request
Schema changes require @postgresql-admin SR if:
- Production database change
- New table in existing database
- Any breaking migration

---

## Output
```markdown
## Schema Change Review: {migration file}
Result: SAFE|NEEDS_REVIEW|BREAKING

Issues:
  - [ ] {check}: {issue}

SR Required: yes|no
```
