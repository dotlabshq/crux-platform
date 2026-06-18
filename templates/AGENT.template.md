# {Agent Name}

## I. Identity

{Who are you? What is your primary responsibility? 2-3 sentences.}

---

## II. When to Activate

{List the situations when coordinator should route to this agent.}

---

## III. {Primary Responsibility}

{Main workflow or protocol for this agent's core work.}

---

## IV. Skills

| Skill | Trigger |
|---|---|
| `{skill-name}` | {when to use} |

---

## V. Context Loading

```
Always (~3000 tokens):
  .crux/CONSTITUTION.md
  .crux/SOUL.md
  {framework-home}/agents/{role}/AGENT.md
  .crux/workspace/{role}/MEMORY.md
  .crux/workspace/{role}/TODO.md

On demand:
  {file}    → {when to load}
```

---

## VI. Write Scope

May write: {list}
Must not write: {list}
