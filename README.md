# env-craft

Claude Code plugin that orchestrates your AI development environment. Detects your tech stack, installs the right skills from [skills.sh](https://skills.sh), applies quality tier rules, and generates a `CLAUDE.md` — all in one command.

## What is this?

env-craft is a **Claude Code plugin** that orchestrates your AI environment by combining:
- **Quality tier rules** (DRY, SOLID, clean-code, architecture patterns) — env-craft's own content, scaled by project size
- **Tech-specific skills** from [skills.sh](https://skills.sh) — maintained by the community and official teams (antfu, nuxt, onmax, etc.)
- **CLAUDE.md generation** — project-aware configuration with tech stack, dev commands, and structure

No more copy-pasting CLAUDE.md files or manually installing skills for each project.

## Install

### From the plugin marketplace (recommended)

```bash
# Install globally (available in all projects)
claude plugin install env-craft --scope user

# Or install for a specific project only
claude plugin install env-craft --scope project
```

### From GitHub

```bash
# Clone the repo
git clone https://github.com/MrSociety404/claude-env-craft.git

# Install from local directory
claude --plugin-dir ./claude-env-craft
```

### Local development / testing

```bash
# Test the plugin without installing
claude --plugin-dir /path/to/claude-env-craft
```

After installation, run `/env-craft init` in Claude Code to set up your project.

## Quick Start

```bash
# Auto-detect your project and set up the environment
/env-craft init

# Or use a preset directly
/env-craft init small-nuxt
/env-craft init large-nuxt-i18n
```

## What You Get

When you run `/env-craft init`, env-craft:

1. **Detects** your framework, dependencies, and project size
2. **Installs quality rules** in `.claude/rules/` based on your project size (tier system)
3. **Installs tech skills** from skills.sh for your stack (nuxt, vue, pinia, etc.)
4. **Generates CLAUDE.md** with your tech stack, dev commands, and project structure
5. **Creates a manifest** (`.claude/env-craft.json`) to track your configuration

## Core Concepts

### Bases

Foundation tied to a tech stack — determines which skills.sh packages to install:
- `frontend-nuxt` — Nuxt 4+ (installs `antfu/skills@nuxt`, `antfu/skills@vue`, `wshobson/agents@typescript-advanced-types`)

*Coming soon: `backend-node`, `fullstack-nuxt`, `backend-python`*

### Size Modifiers (Quality Tiers)

Control rule strictness via a three-tier system. These are env-craft's own rules — quality patterns that scale with your project:

| Size | Tiers | What you get |
|------|-------|-------------|
| `@small` | Core | Quality basics: DRY, naming, clean code, consistency. No architecture enforcement. |
| `@medium` | Core + Structure | Adds folder architecture, separation of concerns, strict typing. |
| `@large` | Core + Structure + Patterns | Adds SOLID, dependency injection, layered architecture. |

`@small` is not "fewer rules" — it's **quality without ceremony**. You still get DRY, clean code, and consistent naming. You just don't get forced into service layers and DI patterns for a 10-component app.

### Modules

Add-on blocks that map to skills.sh packages:

| Module | Skills.sh package installed |
|--------|-----------------------------|
| `+i18n` | *(detected, no specific skill yet)* |
| `+pinia` | `antfu/skills@pinia` |
| `+ui-nuxt-ui` | `nuxt/ui@nuxt-ui` |
| `+content-nuxt` | `onmax/nuxt-skills@nuxt-content` |
| `+vueuse` | `antfu/skills@vueuse-functions` |

### Extra Skills Detection

env-craft also detects dependencies that don't have a module but have a skills.sh skill:
- `drizzle-orm` → `bobmatnyc/claude-mpm-skills@drizzle-orm`
- `tailwindcss` → `wshobson/agents@tailwind-design-system`
- `motion-v` → `onmax/nuxt-skills@motion`
- `@nuxt/seo` → `onmax/nuxt-skills@nuxt-seo`

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
| `/env-craft list` | Show current env: base, size, modules, skills |
| `/env-craft templates` | Browse available bases, modules, presets |
| `/env-craft import <url>` | Import an external module from GitHub |
| `/env-craft eject` | Stop using env-craft, keep generated files |

## Plugin Structure

```
env-craft/                          # Plugin root (${CLAUDE_PLUGIN_ROOT})
├── .claude-plugin/
│   └── plugin.json                 # Plugin manifest
├── skills/
│   └── env-craft/
│       └── SKILL.md                # The orchestrator skill
├── bases/                          # Base definitions (skills.sh mappings per stack)
│   └── frontend-nuxt/
│       └── env-craft-module.json
├── tiers/                          # Quality tier rules (env-craft's own content)
│   ├── core/rules/                 # Always applied (DRY, naming, clean-code, consistency)
│   ├── structure/rules/            # @medium + @large (folder-architecture, typing, SoC)
│   └── patterns/rules/             # @large only (SOLID, DI, layered-architecture)
├── sizes/                          # Size → tier mappings
│   ├── small.json
│   ├── medium.json
│   └── large.json
├── modules/                        # Module definitions (skills.sh mappings per dependency)
│   ├── i18n/
│   ├── pinia/
│   ├── ui-nuxt-ui/
│   ├── content-nuxt/
│   └── vueuse/
├── presets/                        # Curated combinations
│   ├── small-nuxt.json
│   ├── medium-nuxt.json
│   └── large-nuxt-i18n.json
├── external/                       # Imported GitHub modules
├── env-craft.schema.json           # Manifest schema
└── README.md
```

## Contributing

### Add a new module

Create a folder in `modules/<name>/` with an `env-craft-module.json`:

```json
{
  "name": "my-module",
  "type": "module",
  "description": "What this module adds",
  "compat": ["frontend-nuxt"],
  "skills_sh": ["owner/repo@skill-name"]
}
```

The `skills_sh` array contains full skills.sh package identifiers that will be installed when this module is active.

### Add a new base

Create a folder in `bases/<name>/` with an `env-craft-module.json`:

```json
{
  "name": "my-base",
  "type": "base",
  "description": "Base for X framework",
  "compat": [],
  "skills_sh": ["owner/repo@skill1", "owner/repo@skill2"]
}
```

### Add a new preset

Create a JSON file in `presets/<name>.json`:

```json
{
  "name": "my-preset",
  "description": "Description of this preset",
  "base": "frontend-nuxt",
  "size": "medium",
  "modules": ["i18n", "pinia"]
}
```

## Roadmap

- [ ] More bases: `backend-node`, `fullstack-nuxt`, `backend-python`
- [ ] More modules: `+testing-vitest`, `+drizzle`, `+motion`, `+nuxt-seo`
- [ ] Publish to official Claude plugin marketplace
- [ ] Auto-update skills with `npx skills check`
