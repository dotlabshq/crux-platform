# Workflow: incident-response

## Trigger
Production alert, "something is broken", "prod is down".

---

## Steps

1. Triage (coordinator, immediate) — `incident-triage` skill → P0-P3 + incident ID
2. P0/P1: notify human immediately
3. Diagnosis (assigned agent)
4. Mitigation — P0: rollback first, fix second. Human approval for any prod change.
5. Resolution — update incident record
6. Post-mortem (coordinator) — failure archaeology, ADR if needed, monitoring improvement

## SLA
P0: first response <5min, mitigation <1hr
P1: first response <30min, mitigation <4hr
P2: first response <2hr, fix <24hr
P3: acknowledged <24hr, fix next sprint
