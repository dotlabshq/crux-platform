# Incident Severity Matrix

## P0 — Critical (immediate response)
- Active data breach or suspected breach
- Authentication system completely down
- Data corruption affecting multiple tenants
- Active exploitation of a vulnerability
- Complete service outage

## P1 — High (< 1 hour response)
- Security vulnerability discovered in production
- Partial auth failure (some users affected)
- Abnormal data access patterns suggesting attack
- Failed login spike suggesting credential stuffing

## P2 — Medium (< 4 hours)
- Security misconfiguration found (not actively exploited)
- Dependency with known CVE (non-critical)
- Single tenant affected
- Access control bug (no evidence of exploitation)

## P3 — Low (next business day)
- Low-severity CVE in dependency
- Security improvement recommendation
- Security documentation gap

## Response Owners

P0: @security-lead immediately + @ciso-advisor + human escalation
P1: @security-lead primary + human notification
P2/P3: @security-lead triages, routes to appropriate agent
