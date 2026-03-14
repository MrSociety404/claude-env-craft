---
name: Nuxt UI Conventions
description: Nuxt UI v4 component patterns and theming
paths: ["**/*.vue", "app.config.ts"]
---

- Use Nuxt UI components (UButton, UInput, UModal, UTable, etc.) instead of custom equivalents
- Theming via `app.config.ts` — don't override component styles with raw CSS
- Use Tailwind Variants for component style customization via `ui` prop
- Form validation: use UForm with Zod/Yup schemas, not manual validation
- Icons: use Nuxt UI's icon system with Iconify names, no custom SVG imports
- Responsive design through Tailwind breakpoint utilities, not custom media queries
- Color mode: use `useColorMode()` composable, not manual dark/light logic
- Toast notifications via `useToast()`, not custom notification systems
