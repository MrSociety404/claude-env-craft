---
name: Nuxt Conventions
description: Nuxt 4+ framework conventions and best practices
paths: ["app/**", "pages/**", "components/**", "composables/**", "server/**", "layouts/**", "middleware/**"]
---

- Use `definePageMeta` for page-level configuration
- Server routes go in `server/api/` with method suffixes: `.get.ts`, `.post.ts`, `.put.ts`, `.delete.ts`
- Use `useRuntimeConfig()` for environment variables, never `process.env` in client code
- Prefer `useFetch`/`useAsyncData` over raw `$fetch` in components for SSR support
- Use auto-imports — don't manually import Vue/Nuxt composables
- Layouts define page structure, pages define content — no layout logic in pages
- Middleware for route guards: named middleware in `middleware/`, inline for one-off checks
