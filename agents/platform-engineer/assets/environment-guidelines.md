# Environment Guidelines

## Environment Naming

```
development   local developer environment
staging       pre-production, mirrors prod config
production    live, customer-facing
```

## Environment Parity

Staging must mirror production:
- Same infrastructure type
- Same environment variables (with staging values)
- Same deployment process
- Different: data (anonymized), scale (smaller), costs

## Configuration Management

```
Required in .env.example:
  Every env var the application needs
  With description comment
  With example value (not real secrets)

Required in SOUL.md:
  Which env vars differ between deployment modes
  Which are required vs optional
```

## Never Do

- Different deployment process for staging vs prod
- Skip staging and deploy direct to prod
- Hardcode environment-specific values in code
