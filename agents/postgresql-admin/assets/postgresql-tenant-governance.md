# PostgreSQL Tenant Governance

## Row-Level Security (RLS)

For SAAS deployments, enable RLS on all tenant-owned tables:

```sql
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON projects
  USING (org_id = current_setting('app.current_org_id')::text);
```

Set at connection/transaction level:
```sql
SET LOCAL app.current_org_id = 'org_xxx';
```

## Tenant Provisioning

New tenant checklist:
- [ ] Organization record created
- [ ] Default workspace created
- [ ] Admin user linked via membership
- [ ] Quotas set (if applicable)
- [ ] Audit log entry created

## Tenant Data Isolation Verification

Monthly check: run cross-tenant query test
```sql
-- Should return 0 rows if isolation correct
SELECT COUNT(*) FROM projects p1
JOIN projects p2 ON p1.org_id != p2.org_id
WHERE p1.id = p2.id;
```
