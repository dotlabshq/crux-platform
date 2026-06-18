# Version Policy

## Semantic Versioning

MAJOR (x.0.0) — breaking change (any change requiring consumer code changes)
MINOR (0.x.0) — new feature, backward compatible
PATCH (0.0.x) — bug fix, security fix

When in doubt: MAJOR.

## Support Windows

CURRENT:     Full support. Active development.
CURRENT-1:   Security patches only.
CURRENT-2:   Critical security fixes only.
CURRENT-3:   EOL. 6-month migration window.
CURRENT-4+:  Blocked. Build fails.

## EOL Timeline

T-6 months: EOL announced. Consumers notified. Migration guide published.
T-3 months: Reminder. Runtime deprecation warning in SDK.
T-0:        EOL. SDK throws error. CI blocks.

## Consumer Policy

Max 3 major versions behind current. Security patches within 30 days.
