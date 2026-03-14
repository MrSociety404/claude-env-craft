---
name: Naming Conventions
description: Consistent, meaningful naming across all code
tier: core
---

- Names indicate role/content, not type (e.g. `users` not `userArray`)
- Booleans use prefixes: `isActive`, `shouldRefresh`, `hasAccess`, `mustValidate`
- Functions describe actions: `fetchUsers`, `calculateTotal`, `formatDate`
- Adapt name length to scope — short for local, descriptive for exported
- All code in English: variable names, function names, comments
- No abbreviations unless universally understood (`id`, `url`, `config`)
- Constants use UPPER_SNAKE_CASE: `MAX_RETRIES`, `DEFAULT_TIMEOUT`
