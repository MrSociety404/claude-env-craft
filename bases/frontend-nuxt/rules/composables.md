---
name: Composables
description: Vue composable patterns and conventions
paths: ["composables/**", "**/*.ts"]
---

- Composable names start with `use` prefix: `useAuth`, `useCart`, `useFilters`
- Return reactive refs/computed, not raw values
- Accept refs as arguments for reactivity chaining
- Keep composables focused — one concern per composable
- Composables encapsulate state + logic, components handle rendering
- Shared state composables use `useState` for SSR-safe global state
