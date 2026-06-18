# Component Structure Guidelines

## File Organization

```
components/
  {feature}/
    {component-name}.tsx      ← component
    {component-name}.test.tsx ← tests
    index.ts                  ← exports
```

## Component Rules

- One component per file
- Props interface defined before component
- No inline styles — use design system tokens
- All interactive elements keyboard accessible
- Loading and error states always handled

## State Management

- Local state: useState / useReducer
- Server state: follow project's data-fetching pattern (SWR, React Query, etc.)
- Never fetch data in presentation components — use container pattern

## Naming

- Components: PascalCase
- Files: kebab-case
- Props: camelCase
- CSS classes: kebab-case (Tailwind: as-is)
