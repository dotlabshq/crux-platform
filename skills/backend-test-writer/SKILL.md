---
name: backend-test-writer
description: >
  Write backend tests: unit (happy path, edge cases, errors),
  integration (auth, tenant isolation, valid/invalid input). Tests must
  pass before task is done. Trigger: after backend implementation
  complete.
temperature: 0.2
permission:
  skill:
    "*": allow
color: "#2563eb"
emoji: 🧪
---
# backend-test-writer

## Trigger
After backend implementation complete. "Write tests", "add tests", "test coverage".

---

## Test Strategy

### Unit Tests
For each function/method:
- Happy path
- Edge cases (empty input, null, boundary values)
- Error cases

### Integration Tests
For each API endpoint:
- Auth required endpoints return 401 without token
- Tenant isolation: user from org A cannot access org B resources
- Valid input returns expected response
- Invalid input returns 400 with clear error

### Test Naming
```
describe('POST /api/v1/workspaces', () => {
  it('creates workspace with valid input', ...)
  it('returns 401 without auth token', ...)
  it('returns 409 when slug already exists', ...)
  it('cannot access another org workspace', ...)
})
```

### Coverage
Aim for 80%+ line coverage on new code. Focus on critical paths and edge cases over raw percentage.

---

## Output
Test file(s) alongside implementation. Tests must pass before task is `done`.
