---
name: Folder Architecture
description: Enforce organized file structure and module boundaries
tier: structure
---

- Group files by feature/domain, not by type (co-location principle)
- Keep a clear separation between layers (UI, business logic, data access)
- Index files re-export public API: prefer `export * from './module'`
- Each directory should have a clear single responsibility
- Avoid deep nesting — max 4 levels from project root
- Shared utilities go in a dedicated shared/utils directory
- Configuration files belong at project root or in a config directory
