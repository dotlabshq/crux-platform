# Deployment Model

Model: {SAAS|ON_PREM|SELF_HOSTED|ALL}
Determined by: {wrangler.toml|docker-compose.yml|k8s/|manual}

## Agent Implications

### @backend-developer
SAAS: tenant_id isolation enforced on all queries. Failure blocks PR.
ON_PREM: single-tenant, isolation optional.
SELF_HOSTED: schema migrations must include rollback + upgrade script.
ALL: DEPLOYMENT_MODE env flag controls behavior.

### @platform-engineer
SAAS: managed infra, CI/CD focus.
ON_PREM: Kubernetes manifests + Helm charts.
SELF_HOSTED: Docker Compose + upgrade scripts.

### @platform-steward
SAAS: breaking changes need cross-project consumer notification.
ON_PREM/SELF_HOSTED: release notes + migration guide per release.

## DEPLOYMENT_MODE Flag
DEPLOYMENT_MODE=SAAS|ON_PREM|SELF_HOSTED

## Tenant Isolation Enforcement
SAAS:         enforced — tenant-isolation-audit blocks merge on failure
ON_PREM:      optional — advisory only
SELF_HOSTED:  optional — advisory only
ALL:          enforced (treat as SAAS)
