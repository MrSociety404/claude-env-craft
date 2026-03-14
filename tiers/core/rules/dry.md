---
name: DRY - Don't Repeat Yourself
description: Eliminate code duplication across all project sizes
tier: core
---

- Never duplicate logic — extract shared code into reusable functions
- If the same pattern appears 2+ times, refactor into a single source of truth
- Shared constants must be defined once and imported where needed
- Utility functions belong in a shared location, not copy-pasted across files
- When fixing a bug, check if the same pattern exists elsewhere and fix all instances
