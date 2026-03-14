---
name: Pinia Stores
description: Pinia state management conventions
paths: ["stores/**", "**/*.vue", "composables/**"]
---

- Use setup syntax (`defineStore('name', () => { ... })`) over options syntax
- Store names use camelCase with `use` prefix: `useCartStore`, `useAuthStore`
- One store per domain/feature — no god stores
- Actions for async operations and complex mutations
- Getters (computed) for derived state
- Don't access stores in other stores directly — use composables to coordinate
- Components call store actions, never mutate state directly outside the store
- Reset store state on logout/cleanup with `$reset()` or explicit reset action
