---
name: Separation of Concerns
description: Keep different responsibilities in separate modules
tier: structure
---

- Business logic must not live in UI components or route handlers
- Data fetching logic is separate from data transformation
- Validation logic is separate from business logic
- Side effects (API calls, storage) are isolated from pure logic
- Each module/file has a single clear responsibility
- Avoid god files — split when a file handles multiple unrelated concerns
