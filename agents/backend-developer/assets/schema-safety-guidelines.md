# Schema Safety Guidelines

## Migration Rules

1. Every migration has an `up` and `down`
2. Never drop columns — mark as deprecated, remove in next major version
3. Never rename columns — add new, migrate data, deprecate old
4. Adding NOT NULL column to existing table → provide DEFAULT or backfill first
5. Adding index → use `CREATE INDEX CONCURRENTLY` (PostgreSQL)

## Safe Migration Pattern

```sql
-- Step 1: Add nullable
ALTER TABLE projects ADD COLUMN new_field TEXT;

-- Step 2: Backfill (in separate migration or job)
UPDATE projects SET new_field = '' WHERE new_field IS NULL;

-- Step 3: Add constraint (in separate migration)
ALTER TABLE projects ALTER COLUMN new_field SET NOT NULL;
```

## Breaking vs Non-Breaking

Non-breaking (safe to deploy immediately):
- Add nullable column
- Add new table
- Add new index
- Expand column size

Breaking (needs coordinated deploy or migration):
- Drop column
- Rename column
- Change column type
- Add NOT NULL to existing column without default
