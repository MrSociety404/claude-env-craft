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

You are the env-craft environment manager. You help users create, maintain, and evolve their Claude development environment based on project type and scale.

## Path Resolution

**CRITICAL:** All template paths are relative to the env-craft source root, NOT the target project.

Resolve the source root from the skill location:
```
ENV_CRAFT_ROOT = ${CLAUDE_SKILL_DIR}/../..
```

`${CLAUDE_SKILL_DIR}` points to this skill's directory (e.g. `src/skills/env-craft/`).
Going up two levels gives us `src/` — the root of all env-craft templates.

**Use `ENV_CRAFT_ROOT` for reading templates** (bases, tiers, modules, presets, sizes).
**Use the target project's working directory** for writing assembled output and symlinks.

## Directory Structure

All templates live in `ENV_CRAFT_ROOT/`:
- `ENV_CRAFT_ROOT/bases/<name>/` — Base templates (one per tech stack)
- `ENV_CRAFT_ROOT/tiers/{core,structure,patterns}/rules/` — Tiered rules
- `ENV_CRAFT_ROOT/sizes/{small,medium,large}.json` — Size → tier mappings
- `ENV_CRAFT_ROOT/modules/<name>/` — Add-on modules
- `ENV_CRAFT_ROOT/presets/<name>.json` — Curated combinations
- `ENV_CRAFT_ROOT/external/<name>/` — Imported external modules

Assembled output is written to the **target project**:
- `.claude/rules/` — Merged rules from tiers + base + modules
- `.claude/skills/` — Merged skills from base + modules
- `.claude/agents/` — Merged agents from base + modules

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
3. Re-assemble (removes that module's files from output)
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
4. Check if any assembled rules reference tools/frameworks not in the project
5. Report findings and suggest fixes
6. Ask user if they want to apply suggested changes

### `/env-craft list`

1. Read `.claude/env-craft.json`
2. Display: base, size, active tiers, installed modules (with source), last assembled timestamp

### `/env-craft templates`

1. Scan `ENV_CRAFT_ROOT/bases/` for available bases
2. Scan `ENV_CRAFT_ROOT/modules/` for available modules
3. Scan `ENV_CRAFT_ROOT/presets/` for available presets
4. Display organized catalog with descriptions

### `/env-craft import <github-url>`

1. Clone/fetch the repo content
2. Look for `env-craft-module.json` in repo root
3. Validate structure: must have `env-craft-module.json` + at least one of `rules/`, `skills/`, `agents/`
4. Check compatibility with current base
5. Copy into `ENV_CRAFT_ROOT/external/<module-name>/`
6. Add to manifest with `source: "github:<owner>/<repo>"` and commit hash
7. Re-assemble
8. Report what was imported

### `/env-craft eject`

1. The assembled files are already in `.claude/rules/`, `.claude/skills/`, `.claude/agents/`
2. Remove `.claude/env-craft.json`
3. Warn: "Environment ejected. Files are now standalone — env-craft commands will no longer work."

## Assembly Process

**CRITICAL:** Use `Bash(cp ...)` commands for all file operations during assembly. Do NOT use the Write tool to copy template files — it triggers per-file permission prompts. A single Bash call with multiple `cp` commands requires only one permission approval.

When assembling, follow this exact order:

### Step 1: Prepare output directories and copy all files in one Bash call

Build a single Bash command that does everything:

```bash
# 1. Prepare directories
mkdir -p .claude/rules .claude/skills .claude/agents
rm -f .claude/rules/*.md

# 2. Copy tier rules (for each active tier from manifest)
cp ${ENV_CRAFT_ROOT}/tiers/<tier>/rules/*.md .claude/rules/ 2>/dev/null || true

# 3. Copy base rules
cp ${ENV_CRAFT_ROOT}/bases/<base>/rules/*.md .claude/rules/ 2>/dev/null || true

# 4. Copy base skills (preserve per-skill subdirectories)
# For each skill dir in bases/<base>/skills/:
cp -r ${ENV_CRAFT_ROOT}/bases/<base>/skills/<skill-name> .claude/skills/ 2>/dev/null || true

# 5. Copy base agents (preserve per-agent subdirectories)
# For each agent dir in bases/<base>/agents/:
cp -r ${ENV_CRAFT_ROOT}/bases/<base>/agents/<agent-name> .claude/agents/ 2>/dev/null || true

# 6. Copy module rules/skills/agents (for each module)
cp ${ENV_CRAFT_ROOT}/modules/<module>/rules/*.md .claude/rules/ 2>/dev/null || true
# Same pattern for skills/ and agents/ subdirectories
```

Combine ALL copy operations into a **single Bash tool call** chained with `&&` or `;`. This way the user approves once.

Do NOT delete `.claude/skills/` contents blindly — it may contain other skills not managed by env-craft.

### Step 2: Generate CLAUDE.md

Generate a `CLAUDE.md` file at the project root with:

```markdown
# [Project Name]

## Tech Stack
[Auto-detected: framework, UI library, key dependencies]

## Development
[Commands from package.json scripts: dev, build, test, lint, typecheck]

## Project Structure
[Brief description of key directories based on actual folder scan]

## Rules
This project uses env-craft rules in `.claude/rules/`. Run `/env-craft list` to see the current configuration.
```

**IMPORTANT:** Read the existing `CLAUDE.md` first. If it exists, ask the user whether to replace it, merge with it, or skip. Never silently overwrite.

### Step 3: Recommend skills

Read the `skills_sh` field from each active module's `env-craft-module.json` and from the base's `env-craft-module.json`. Collect all recommended skill names.

Present the list to the user:
```
Recommended skills for your stack:
- nuxt (from base: frontend-nuxt)
- nuxt-content (from module: +content-nuxt)
- nuxt-ui (from module: +ui-nuxt-ui)
- vueuse (from module: +vueuse)

Install them? You can install from skills.sh or manually.
```

If the user confirms, check if the skills are already installed in `.claude/skills/`. For skills available on skills.sh, suggest the install command. Don't auto-install without confirmation.

### Step 4: Update manifest

Use the Write tool to create/update `.claude/env-craft.json` with current config and set `assembled_at` to current ISO timestamp.

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

**Size estimation**:
- Count `.vue` files, `.ts` files, directories under `src/` or `app/`
- < 15 components, < 30 total files → suggest `@small`
- 15-50 components, 30-100 files → suggest `@medium`
- > 50 components or > 100 files → suggest `@large`

## Key Principles

- **Never auto-apply** — always show what will change and ask for confirmation
- **Idempotent assembly** — running assemble twice produces the same result
- **Backward compatible** — adding a module never removes existing rules
- **Transparent** — always report what was added/removed/changed
- **Portable** — all source paths resolved via `${CLAUDE_SKILL_DIR}`, works from any project
