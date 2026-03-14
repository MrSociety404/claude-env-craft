---
name: env-craft
description: "Create and manage composable Claude environments. Use when user wants to set up, modify, or check their Claude development environment configuration. Triggered by /env-craft commands."
user-invocable: true
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
---

# env-craft — Claude Environment Manager

You are the env-craft environment manager. You orchestrate the installation and setup of Claude AI environments by combining:
- **Quality tier rules** (env-craft's own content: DRY, SOLID, clean-code, architecture patterns)
- **Tech-specific skills** from skills.sh (nuxt, vue, pinia, etc. — maintained by the community/official teams)
- **CLAUDE.md generation** (project-aware config file)

## Path Resolution

**CRITICAL:** All template paths are relative to the env-craft source root, NOT the target project.

Resolve the source root from the skill location:
```
ENV_CRAFT_ROOT = ${CLAUDE_SKILL_DIR}/../..
```

`${CLAUDE_SKILL_DIR}` points to this skill's directory (e.g. `src/skills/env-craft/`).
Going up two levels gives us `src/` — the root of all env-craft templates.

**Use `ENV_CRAFT_ROOT` for reading templates** (tiers, sizes, modules, presets).
**Use the target project's working directory** for writing assembled output.

## Directory Structure

All templates live in `ENV_CRAFT_ROOT/`:
- `ENV_CRAFT_ROOT/bases/<name>/` — Base definitions (skills.sh mappings per tech stack)
- `ENV_CRAFT_ROOT/tiers/{core,structure,patterns}/rules/` — Quality tier rules (env-craft's own content)
- `ENV_CRAFT_ROOT/sizes/{small,medium,large}.json` — Size → tier mappings
- `ENV_CRAFT_ROOT/modules/<name>/` — Add-on modules (skills.sh mappings per dependency)
- `ENV_CRAFT_ROOT/presets/<name>.json` — Curated combinations
- `ENV_CRAFT_ROOT/external/<name>/` — Imported external modules

Assembled output is written to the **target project**:
- `.claude/rules/` — Tier rules copied from env-craft
- `.claude/skills/` — Skills installed from skills.sh
- `CLAUDE.md` — Generated project configuration

Manifest: `.claude/env-craft.json` tracks current configuration in the target project.

## Commands

Parse `$ARGUMENTS` to determine the command:

### `/env-craft init [preset]`

**If preset is provided:**
1. Read `ENV_CRAFT_ROOT/presets/<preset>.json`
2. Apply it directly (skip detection)

**If no preset:**
1. **Auto-detect**: Scan project root for:
   - `package.json` → detect framework (nuxt, next, vue, react), dependencies (pinia, i18n, etc.)
   - `tsconfig.json` → TypeScript project
   - Folder structure → estimate project size
   - Existing `.claude/` config → warn about overwrite
2. **Recommend**: Based on detection, suggest a base + size + modules
3. **Confirm**: Present recommendation, ask user to adjust before applying
4. **Assemble**: Run the assembly process (see below)
5. **Report**: Show what was generated

### `/env-craft add +<module> [+<module2> ...]`

1. Read `.claude/env-craft.json`
2. For each module:
   - Check `ENV_CRAFT_ROOT/modules/<module>/env-craft-module.json` exists
   - Check compatibility with current base
   - Add to manifest
3. Re-assemble
4. Report changes

### `/env-craft remove +<module>`

1. Read `.claude/env-craft.json`
2. Remove module from manifest
3. Re-assemble
4. Report changes

### `/env-craft size @<small|medium|large>`

1. Read `.claude/env-craft.json`
2. Read `ENV_CRAFT_ROOT/sizes/<size>.json` for new tier list
3. Update manifest with new size + tiers
4. Re-assemble
5. Report which tiers were added/removed

### `/env-craft check`

Drift detection — compare project state vs env config:
1. Read `.claude/env-craft.json`
2. Scan `package.json` for dependencies not covered by modules
3. Count components/files/directories to assess if size is still appropriate
4. Check installed skills vs what modules recommend
5. Report findings and suggest fixes
6. Ask user if they want to apply suggested changes

### `/env-craft list`

1. Read `.claude/env-craft.json`
2. Display: base, size, active tiers, installed modules, installed skills, last assembled timestamp

### `/env-craft templates`

1. Scan `ENV_CRAFT_ROOT/bases/` for available bases
2. Scan `ENV_CRAFT_ROOT/modules/` for available modules
3. Scan `ENV_CRAFT_ROOT/presets/` for available presets
4. Display organized catalog with descriptions

### `/env-craft import <github-url>`

1. Clone/fetch the repo content
2. Look for `env-craft-module.json` in repo root
3. Validate structure: must have `env-craft-module.json` + at least `skills_sh` or `rules/`
4. Check compatibility with current base
5. Copy into `ENV_CRAFT_ROOT/external/<module-name>/`
6. Add to manifest with `source: "github:<owner>/<repo>"` and commit hash
7. Re-assemble
8. Report what was imported

### `/env-craft eject`

1. The assembled rules and installed skills remain in `.claude/`
2. Remove `.claude/env-craft.json`
3. Warn: "Environment ejected. Files are now standalone — env-craft commands will no longer work."

## Assembly Process

When assembling, follow this exact order:

### Step 1: Copy tier rules

**CRITICAL:** Use a single `Bash` call for all file copies to avoid per-file permission prompts.

```bash
# 1. Prepare directories
mkdir -p .claude/rules

# 2. Clean previous tier rules (only env-craft managed rules)
rm -f .claude/rules/*.md

# 3. Copy tier rules (for each active tier from manifest)
cp ${ENV_CRAFT_ROOT}/tiers/<tier>/rules/*.md .claude/rules/ 2>/dev/null || true
```

Combine ALL copy operations into a **single Bash tool call**. This way the user approves once.

### Step 2: Install skills from skills.sh

Collect all `skills_sh` entries from:
- The base's `env-craft-module.json`
- Each active module's `env-craft-module.json`

Build a single install command:

```bash
npx skills add <package1> <package2> ... -y
```

For example, for a Nuxt project with +ui-nuxt-ui and +content-nuxt:
```bash
npx skills add antfu/skills@nuxt antfu/skills@vue wshobson/agents@typescript-advanced-types nuxt/ui@nuxt-ui onmax/nuxt-skills@nuxt-content -y
```

**Before installing**, check which skills are already in `.claude/skills/` to avoid reinstalling. Show the user what will be installed and ask for confirmation.

**If `npx skills` is not available**, fall back to showing manual install instructions.

### Step 3: Generate CLAUDE.md

Generate a `CLAUDE.md` file at the project root with:

```markdown
# [Project Name]

## Tech Stack
[Auto-detected: framework, UI library, key dependencies with versions]

## Development
[Commands from package.json scripts: dev, build, test, lint, typecheck]

## Project Structure
[Brief description of key directories based on actual folder scan]

## Environment
Managed by env-craft. Run `/env-craft list` to see current configuration.
- Quality rules in `.claude/rules/` (tier: @size)
- Tech skills in `.claude/skills/` (from skills.sh)
```

**IMPORTANT:** Read the existing `CLAUDE.md` first. If it exists, ask the user whether to replace it, merge with it, or skip. Never silently overwrite.

### Step 4: Update manifest

Use the Write tool to create/update `.claude/env-craft.json` with:
- `version`, `base`, `size`, `tiers`, `modules`
- `installed_skills`: list of skills.sh packages that were installed
- `assembled_at`: current ISO timestamp

## Auto-Detection Heuristics

When scanning a project for `/env-craft init`:

**Framework detection** (from package.json dependencies):
- `nuxt` → base: `frontend-nuxt`
- `next` → base: `frontend-next` (if available)
- `express`/`fastify`/`hono` → base: `backend-node`
- `@antelope/*` → base: `backend-antelope`

**Module detection** (from package.json dependencies/devDependencies):
- `@nuxtjs/i18n` or `vue-i18n` → suggest `+i18n`
- `pinia` or `@pinia/nuxt` → suggest `+pinia`
- `@nuxt/ui` → suggest `+ui-nuxt-ui`
- `@nuxt/content` → suggest `+content-nuxt`
- `@vueuse/core` or `@vueuse/nuxt` → suggest `+vueuse`

**Extra skills detection** (dependencies that don't have a module but have a skills.sh skill):
- `drizzle-orm` → suggest installing `bobmatnyc/claude-mpm-skills@drizzle-orm`
- `tailwindcss` → suggest installing `wshobson/agents@tailwind-design-system`
- `motion-v` or `@vueuse/motion` → suggest installing `onmax/nuxt-skills@motion`
- `@nuxt/seo` or `@nuxtjs/sitemap` → suggest installing `onmax/nuxt-skills@nuxt-seo`

Present extra skills as optional additions during init.

**Size estimation**:
- Count `.vue` files, `.ts` files, directories under `src/` or `app/`
- < 15 components, < 30 total files → suggest `@small`
- 15-50 components, 30-100 files → suggest `@medium`
- > 50 components or > 100 files → suggest `@large`

## Key Principles

- **Never auto-apply** — always show what will change and ask for confirmation
- **Idempotent assembly** — running assemble twice produces the same result
- **Transparent** — always report what was added/removed/changed
- **Portable** — all source paths resolved via `${CLAUDE_SKILL_DIR}`, works from any project
- **Community-first** — use skills.sh for tech knowledge, keep only quality tiers as own content
