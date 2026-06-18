# Kubernetes Operations Principles

## Change Management

All cluster changes:
1. Document the change and expected outcome
2. Test in staging/dev cluster first
3. Get human approval for production
4. Execute during low-traffic window
5. Monitor 30 minutes post-change

## Namespace Standards

```yaml
# Standard namespace labels
labels:
  environment: staging|production
  team: {team-name}
  project: {project-slug}
  managed-by: crux-platform
```

## Resource Quotas (default per namespace)

```yaml
requests.cpu: 2
requests.memory: 4Gi
limits.cpu: 4
limits.memory: 8Gi
pods: 20
```

Adjust per team based on actual needs.

## Upgrade Protocol

1. Check upgrade path (no skipping minor versions)
2. Review breaking changes in release notes
3. Test workloads in staging cluster post-upgrade
4. Upgrade production during maintenance window
5. Monitor 2 hours post-upgrade

## Security Baseline

- No privileged pods unless explicitly approved
- No host network access unless required
- Network policies default-deny per namespace
- RBAC: least privilege, no cluster-admin for applications
