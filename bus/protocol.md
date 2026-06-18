# Bus Protocol

The bus enables async event communication between agents.

Events are written to `.crux/workspace/bus/events.md` (append-only).

## Event Format

```markdown
## EVT-{ulid}
type: {event-type}
from: @{agent}
timestamp: {ISO timestamp}
payload:
  {key}: {value}
```

## Standard Events

```
agent.onboarded     → coordinator, when agent completes onboarding
task.completed      → coordinator, when agent finishes a task
capability.added    → coordinator, when new capability built
gate.approved       → all agents, when human approves a gate
incident.resolved   → all agents, when incident closed
```

## Coordinator Listens For

- `agent.onboarded` → update MANIFEST.md
- `task.completed` → update TODO.md
- `capability.added` → update capability-map.md + registry
