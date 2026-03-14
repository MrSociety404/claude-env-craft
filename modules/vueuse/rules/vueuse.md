---
name: VueUse Conventions
description: VueUse composable usage patterns and best practices
paths: ["**/*.vue", "**/*.ts"]
---

- Check VueUse before writing custom composables — most reactive utilities already exist
- Use `@vueuse/nuxt` auto-imports — don't manually import from `@vueuse/core`
- Prefer VueUse composables over browser APIs: `useLocalStorage` over `localStorage`, `useFetch` over `fetch`, `useClipboard` over navigator.clipboard
- Reactive DOM: use `useElementSize`, `useIntersectionObserver`, `useResizeObserver` instead of manual listeners
- State: use `useStorage`, `useRefHistory`, `useDebouncedRef` for common state patterns
- Events: use `useEventListener` for automatic cleanup instead of manual `addEventListener`/`removeEventListener`
- Don't wrap VueUse composables in additional composables unless adding significant logic
