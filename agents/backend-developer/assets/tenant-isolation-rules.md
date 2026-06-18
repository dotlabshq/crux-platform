# Tenant Isolation Rules

Applies when: deployment model is SAAS or ALL.

## Database Queries

Every query touching tenant-owned data MUST filter by org_id/tenant_id:

```typescript
// CORRECT
const projects = await db.select()
  .from(projectsTable)
  .where(eq(projectsTable.orgId, orgId))

// WRONG — never do this
const projects = await db.select().from(projectsTable)
```

## Schema

Every tenant-owned table MUST have:
```sql
org_id TEXT NOT NULL REFERENCES organizations(id) ON DELETE CASCADE
```

Exceptions (do not require org_id):
- users (via memberships)
- system_config
- audit_logs (use org_id for filtering, not isolation)

## Auth Flow

```
Request → auth middleware → extract org context → pass to handler → pass to query
```

org_id NEVER comes from:
- Request body
- Query parameters
- Path parameters (unless validated against user's membership)

## Cross-Tenant Check

Before returning any resource by ID, verify the resource belongs to the requesting tenant:
```typescript
const project = await db.select().from(projects)
  .where(and(
    eq(projects.id, projectId),
    eq(projects.orgId, orgId)  // ← always include this
  ))
if (!project) throw new NotFoundError()
```
