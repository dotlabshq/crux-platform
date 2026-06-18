# Platform Steward Onboarding

On first activation:

1. Read `.crux/docs/sdk-registry.md` if exists
2. Read `$HOME/.crux/registry/sdk-versions.md`
3. Scan package files across registered projects for SDK imports
4. Write to `workspace/platform-steward/MEMORY.md`:

```markdown
## Managed SDKs
{sdk-name} v{current}: {n} consumers

## Version Health
{sdk}: {all ok | n consumers behind}

## Pending
{EOL notices needed}
{migration guides missing}
```
