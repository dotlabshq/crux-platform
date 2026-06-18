# API Contract Guidelines

## Contract-First Principle

Define the contract before writing implementation. The contract is the source of truth.

## What a Contract Includes

```yaml
endpoint: POST /api/v1/workspaces
auth: required (bearer token)
tenant: required (extracted from token, never from body)
request:
  name: string, required, 1-100 chars
  slug: string, optional, auto-generated if missing
response:
  201: { id, name, slug, createdAt }
  400: { error, details }
  409: { error: "slug already exists" }
errors:
  - missing name → 400
  - duplicate slug → 409
  - invalid auth → 401
```

## REST Conventions

- Resources: plural nouns (`/workspaces`, `/projects`)
- Nested: `/orgs/{orgId}/workspaces/{workspaceId}`
- Versioned: `/api/v1/...`
- Tenant from auth: never `?orgId=` in query params

## Response Shape

```typescript
// Success
{ data: T, meta?: { page, total } }

// Error
{ error: string, details?: Record<string, string> }
```
