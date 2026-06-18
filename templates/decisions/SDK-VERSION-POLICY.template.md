# SDK Version Policy

Adopted: {date}
Applies to: all shared apps (L2)

## Support Windows
CURRENT:     Full support
CURRENT-1:   Security patches only
CURRENT-2:   Critical security fixes only
CURRENT-3:   EOL (6-month migration window)
CURRENT-4+:  BLOCKED — CI fails

## Rules
- Breaking change → MAJOR bump (always)
- New feature (backward compatible) → MINOR bump
- Bug/security fix → PATCH bump
- REST + SDK + MCP always ship together

## EOL Timeline
T-6mo: Announce + publish migration guide
T-3mo: Add runtime deprecation warning
T-0:   SDK throws error, CI blocks

## Consumer Policy
Max 3 major versions behind. Security patches within 30 days.
