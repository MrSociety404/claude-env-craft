---
name: Nuxt Content Conventions
description: Nuxt Content v3 collection patterns, MDC, and content queries
paths: ["content/**", "content.config.ts", "**/*.vue"]
---

- Define content schemas in `content.config.ts` using `defineCollection` with Zod validation
- Use `queryCollection` composable for type-safe content queries, not raw `$fetch`
- Content files use Markdown (`.md`) or YAML (`.yml`) — keep format consistent per collection
- MDC (Markdown Components): use Vue components inside Markdown with `::component-name` syntax
- Organize content by collection: one directory per collection matching the collection name
- Use `usePageContent()` or `useRoute().meta` for page-level content data, not redundant queries
- Front matter fields must match the Zod schema — no undeclared fields
- Images and media referenced in content should use Nuxt Image (`<NuxtImg>`) for optimization
- Use `<ContentRenderer>` for rendering Markdown content, not custom parsers
- Locale-specific content: use i18n directory structure or front matter `locale` field, not duplicated files
