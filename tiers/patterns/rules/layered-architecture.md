---
name: Layered Architecture
description: Enforce strict layer boundaries and data flow direction
tier: patterns
---

- Layers: Controllers/Handlers → Services → Repositories/Adapters
- Dependencies flow inward only — outer layers depend on inner, never reverse
- Each layer communicates through defined interfaces
- No direct database/API access from controllers or UI components
- DTOs at layer boundaries — don't pass raw database entities to the presentation layer
- Cross-cutting concerns (logging, auth, caching) use middleware or decorators, not inline code
