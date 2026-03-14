---
name: Vue Patterns
description: Vue 3 component patterns and conventions
paths: ["**/*.vue"]
---

- Use `<script setup lang="ts">` for all components
- Props: use `defineProps<T>()` with interface, not runtime declaration
- Emits: use `defineEmits<T>()` with typed signatures
- One component per file, filename matches component name (PascalCase)
- Template logic: keep expressions simple — extract complex logic to computed or methods
- Prefer `computed` over methods for derived state
- Use `v-model` with `defineModel()` for two-way binding
- Slots over props for rendering customization
