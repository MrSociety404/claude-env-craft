---
name: Dependency Injection
description: Use DI for decoupled, testable architecture
tier: patterns
---

- Dependencies are injected, not instantiated internally
- Use constructor injection for required dependencies
- Define interfaces/abstractions for all injectable services
- Composition root wires up dependencies at application entry point
- No service locator pattern — explicit injection only
- Mock-friendly design: every external dependency behind an interface
