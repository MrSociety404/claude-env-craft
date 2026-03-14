---
name: Strict Typing
description: Enforce proper TypeScript typing conventions
tier: structure
---

- Define proper interfaces/types — no anonymous inline types like `{ a: string, b: number }`
- No `any` type — use `unknown` when type is truly unknown, then narrow
- Export shared types from dedicated type files
- Use discriminated unions over type assertions
- Generic types for reusable patterns (e.g. `ApiResponse<T>`, `Paginated<T>`)
- Function signatures must have explicit return types for exported functions
