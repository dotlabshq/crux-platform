# Project Constitution

**Version:** 1
**Project:** {name}
**Created:** {date}

---

## Coding Approach

{contract-first | tdd | prototype-first | freestyle}

**Rules:**
- {specific rule from chosen approach}

## Human Loop

{minimal | standard | high}

**Gates:**
- Architecture decisions affecting 2+ projects → human approval
- Production deployments → human approval
- Breaking changes → human approval
- Agent confidence < 0.6 → human review

## Tenant Isolation

**Enforcement:** {enforced | optional} (derived from deployment model)

{SAAS/ALL: Tenant isolation enforced on all database queries. Failure blocks PR.}
{ON_PREM/SELF_HOSTED: Tenant isolation recommended but not blocking.}

## Agent Confidence Threshold

0.6 — agents with confidence below this must surface to human before proceeding.

## SDK Version Policy

Max versions behind: 3 (BLOCKED at 4+)
EOL notice: 6 months minimum

## Amendment Process

1. Agent writes AMD-{id} to MANIFEST.md → Pending Amendments
2. Agent pauses, notifies human
3. Human approves → constitution updated, version incremented
4. Human rejects → agent continues under current rules
