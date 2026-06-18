# Deployment Safety Guidelines

## Pre-Deploy Checklist

Run deployment-readiness skill. All must pass:

- Tests green (CI)
- Coverage meets threshold
- No unresolved security findings
- Changelog updated
- Rollback plan documented or automated
- Staging deployed successfully
- Migration guide if breaking change

## Deployment Strategies

**Canary** (preferred for SaaS):
- Deploy to 5% traffic first
- Monitor error rate and latency 15 minutes
- Promote to 100% or rollback

**Blue/Green** (for major releases):
- New version alongside old
- Switch traffic instantly
- Keep old version running 30 minutes before teardown

**Rolling** (for non-critical services):
- Replace instances one at a time
- Health check between each

## Rollback Triggers

Auto-rollback when:
- Error rate increases >2x baseline
- P99 latency increases >3x baseline
- Health check fails for >2 consecutive checks

## Secrets Management

- Never commit secrets to git
- Use secret manager or env injection
- Rotate secrets on any suspected compromise
- Audit secret access monthly
