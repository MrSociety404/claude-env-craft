# claude-env-craft

Composable Claude environment manager. Generates and maintains `.claude/` configuration tailored to your project type and scale.

## What is this?

claude-env-craft creates the right Claude Code environment for your project — rules, skills, agents, settings — based on your tech stack and project size. No more copy-pasting CLAUDE.md files between projects.

## Install

```bash
# In your target project
mkdir -p .claude/skills
ln -sfn /path/to/claude-env-craft/src/skills/env-craft .claude/skills/env-craft
```

Then run `/env-craft init` in Claude Code.

## Quick Start

```bash
# Auto-detect your project and set up the environment
/env-craft init

# Or use a preset directly
/env-craft init small-nuxt
/env-craft init large-nuxt-i18n
```

## Core Concepts

### Bases

Foundation templates tied to a tech stack:
- `frontend-nuxt` — Nuxt 4+ frontend applications

*Coming soon: `backend-node`, `fullstack-nuxt`, `backend-python`*

### Size Modifiers

Control rule strictness via a three-tier system:

| Size | Tiers | What you get |
|------|-------|-------------|
| `@small` | Core | Quality basics: DRY, naming, clean code, consistency. No architecture enforcement. |
| `@medium` | Core + Structure | Adds folder architecture, separation of concerns, strict typing. |
| `@large` | Core + Structure + Patterns | Adds SOLID, dependency injection, layered architecture. |

`@small` is not "fewer rules" — it's **quality without ceremony**. You still get DRY, clean code, and consistent naming. You just don't get forced into service layers and DI patterns for a 10-component app.

### Modules

Add-on blocks that stack onto a base:
- `+i18n` — Internationalization conventions
- `+pinia` — Pinia store patterns
- `+ui-nuxt-ui` — Nuxt UI v4 conventions
- `+content-nuxt` — Nuxt Content v3 patterns
- `+vueuse` — VueUse composable conventions

### Presets

Curated shortcuts combining base + size + modules:

| Preset | Equivalent |
|--------|-----------|
| `small-nuxt` | `frontend-nuxt @small` |
| `medium-nuxt` | `frontend-nuxt @medium +ui-nuxt-ui +vueuse` |
| `large-nuxt-i18n` | `frontend-nuxt @large +i18n +pinia +ui-nuxt-ui +content-nuxt +vueuse` |

## Commands

| Command | Description |
|---------|-------------|
| `/env-craft init` | Auto-detect project + interactive setup |
| `/env-craft init <preset>` | Apply a preset directly |
| `/env-craft add +module` | Add modules: `/env-craft add +i18n +pinia` |
| `/env-craft remove +module` | Remove a module and reassemble |
| `/env-craft size @large` | Change size modifier and reassemble |
| `/env-craft check` | Drift detection — compare project state vs env config |
| `/env-craft list` | Show current env: base, size, modules |
| `/env-craft templates` | Browse available bases, modules, presets |
| `/env-craft import <url>` | Import an external module from GitHub |
| `/env-craft eject` | Stop using env-craft, keep generated files |

## Project Structure

```
src/
├── bases/                      # Base templates (one per tech stack)
│   └── frontend-nuxt/
│       ├── env-craft-module.json
│       └── rules/
├── tiers/                      # Three-tier rule system
│   ├── core/rules/             # Always applied
│   ├── structure/rules/        # @medium + @large
│   └── patterns/rules/         # @large only
├── sizes/                      # Size → tier mappings
│   ├── small.json
│   ├── medium.json
│   └── large.json
├── modules/                    # Add-on modules
│   ├── i18n/
│   ├── pinia/
│   ├── ui-nuxt-ui/
│   ├── content-nuxt/
│   └── vueuse/
├── presets/                    # Curated combinations
│   ├── small-nuxt.json
│   ├── medium-nuxt.json
│   └── large-nuxt-i18n.json
├── external/                   # Imported GitHub modules
├── skills/
│   └── env-craft/SKILL.md      # The orchestrator skill
└── env-craft.schema.json       # Manifest schema
```

## Contributing

### Add a new module

Create a folder in `src/modules/<name>/` with:

```
my-module/
├── env-craft-module.json    # { name, type: "module", compat: [...] }
└── rules/
    └── my-module.md         # Rules with YAML frontmatter
```

### Add a new base

Create a folder in `src/bases/<name>/` with:

```
my-base/
├── env-craft-module.json    # { name, type: "base" }
└── rules/
    └── *.md                 # Base-specific rules
```

### Add a new preset

Create a JSON file in `src/presets/<name>.json`:

```json
{
  "name": "my-preset",
  "description": "Description of this preset",
  "base": "frontend-nuxt",
  "size": "medium",
  "modules": ["i18n", "pinia"]
}
```

### Import external modules

Anyone can publish a module by creating a GitHub repo with:

```
env-craft-module.json
rules/
  my-rules.md
```

Users install it with `/env-craft import <github-url>`.

## Roadmap

- [ ] More bases: `backend-node`, `fullstack-nuxt`, `backend-python`
- [ ] More modules: `+testing-vitest`, `+drizzle`, `+graphql`, `+saga`
- [ ] skills.sh integration for community skill discovery
- [ ] Plugin packaging for distribution
