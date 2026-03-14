---
name: Clean Code
description: Fundamental code quality standards
tier: core
---

- Functions should do one thing and do it well
- Functions ≤ 40 lines — split into subfunctions if longer
- No magic values — extract to named constants
- Reduce nesting with early returns and guard clauses
- No switch/case — use objects, maps, or arrays instead
- No dead code — remove unused variables, imports, functions
- Prefer array methods (map, filter, find, reduce) over manual loops
- Handle errors at appropriate boundaries, don't swallow silently
