---
name: env-craft
description: "AI environment architect — scans any project, finds relevant skills from skills.sh, applies quality tier rules, generates CLAUDE.md, and suggests agents. Triggered by /env-craft commands."
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

# env-craft — AI Environment Architect

You are the env-craft environment architect. You make any project AI-ready by:
1. **Scanning** the project (any language, any framework)
2. **Discovering** relevant skills from skills.sh dynamically
3. **Applying** quality tier rules scaled to project size
4. **Generating** a CLAUDE.md with full project context
5. **Suggesting** agents, hooks, and settings for the project's workflows

## Path Resolution

```
ENV_CRAFT_ROOT = ${CLAUDE_PLUGIN_ROOT}
```

`${CLAUDE_PLUGIN_ROOT}` points to the env-craft plugin directory.
Only `tiers/` and `sizes/` live there — everything else is dynamically discovered.

## Commands

Parse `$ARGUMENTS` to determine the command:

### `/env-craft init`

Full environment setup in 5 steps:

#### Step 1: Scan the project

Detect the project's language and framework by checking for these files:

| File | Language/Ecosystem |
|------|--------------------|
| `package.json` | JavaScript/TypeScript (Node.js ecosystem) |
| `requirements.txt` / `pyproject.toml` / `Pipfile` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `Gemfile` | Ruby |
| `composer.json` | PHP |
| `pom.xml` / `build.gradle` | Java/Kotlin |
| `pubspec.yaml` | Dart/Flutter |
| `*.csproj` / `*.sln` | C#/.NET |

For each detected dependency file, extract all dependencies (both production and dev).

Also scan the project structure:
- Count source files by extension (`.vue`, `.tsx`, `.py`, `.rs`, etc.)
- Identify key directories (`src/`, `app/`, `server/`, `tests/`, etc.)
- Check for existing `.claude/` configuration
- Detect CI/CD (`.github/workflows/`, `.gitlab-ci.yml`, etc.)
- Detect testing frameworks (vitest, jest, pytest, etc.)
- Detect linting/formatting (eslint, prettier, ruff, etc.)

#### Step 2: Search skills.sh for relevant skills

For each **major dependency** (frameworks, UI libraries, ORMs, etc. — not utility packages), run:

```bash
npx skills find <dependency-name> 2>&1 | head -20
```

Collect results. For each skill found, note:
- Package identifier (`owner/repo@skill`)
- Install count (higher = more trusted)
- Relevance to the project

**Search strategy:**
- Search for the framework first (e.g., `nuxt`, `django`, `rails`)
- Then major libraries (e.g., `tailwind`, `drizzle`, `pinia`)
- Skip utility packages (e.g., `lodash`, `dayjs`) — they rarely have useful skills
- Limit to top 2-3 results per search (prefer highest installs)

#### Step 3: Present findings and let user choose

Present a clear summary:

```
## Project Analysis

**Language:** TypeScript
**Framework:** Nuxt 4.3.1
**Project size:** Medium (33 components, 6 pages)

### Recommended Skills (from skills.sh)

| # | Skill | Installs | Source |
|---|-------|----------|--------|
| 1 | antfu/skills@nuxt | 5.8K | Framework |
| 2 | nuxt/ui@nuxt-ui | 3.3K | @nuxt/ui dependency |
| 3 | onmax/nuxt-skills@nuxt-content | 789 | @nuxt/content dependency |
| 4 | wshobson/agents@tailwind-design-system | 18.2K | tailwindcss dependency |
| 5 | antfu/skills@pinia | 6.1K | pinia dependency |

### Quality Tier: @medium
Core (DRY, naming, clean-code, consistency) + Structure (folder architecture, typing, SoC)

Select skills to install (e.g., "1,2,3,4" or "all" or "none"):
```

**Never auto-install.** Always let the user pick.

#### Step 4: Install selected skills and tier rules

**Install skills** (one Bash call):
```bash
npx skills add <package1> <package2> ... -a claude-code -y
```

Flags:
- `-a claude-code` — install only for Claude Code (not cursor/windsurf/etc.)
- No `-g` — project scope (default), not global
- Symlink is the default (do NOT use `--copy`)
- `-y` — skip skills CLI confirmation

**Copy tier rules** (one Bash call):
```bash
mkdir -p .claude/rules
cp ${ENV_CRAFT_ROOT}/tiers/<tier>/rules/*.md .claude/rules/ 2>/dev/null || true
```

#### Step 5: Generate CLAUDE.md

Read the existing `CLAUDE.md` first. If it exists, ask the user whether to:
- **Replace** — overwrite entirely
- **Merge** — append env-craft sections to existing content
- **Skip** — don't touch it

Generate content:

```markdown
# [Project Name]

## Tech Stack
- **Framework:** [detected framework + version]
- **Language:** [detected language]
- **Key dependencies:** [list major deps with versions]

## Development

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run test` | Run tests |
| `npm run lint` | Lint code |

## Project Structure

- `app/` — [description based on scan]
- `server/` — [description based on scan]
- `content/` — [description based on scan]
- ...

## AI Environment

Managed by env-craft. Run `/env-craft` commands to manage.

### Installed Skills
[List installed skills from skills.sh]

### Quality Rules
Tier: @[size] — [description]
Rules in `.claude/rules/`
```

#### Final: Write manifest

Write `.claude/env-craft.json`:
```json
{
  "version": "1.0.0",
  "size": "medium",
  "tiers": ["core", "structure"],
  "installed_skills": [
    "antfu/skills@nuxt",
    "nuxt/ui@nuxt-ui"
  ],
  "detected_stack": {
    "language": "typescript",
    "framework": "nuxt",
    "dependencies": ["@nuxt/ui", "@nuxt/content", "pinia"]
  },
  "assembled_at": "2026-03-14T15:00:00.000Z"
}
```

### `/env-craft check`

Drift detection — find what changed since last init:

1. Read `.claude/env-craft.json`
2. Re-scan `package.json` (or equivalent) for new/removed dependencies
3. For new dependencies, search skills.sh for relevant skills
4. Re-estimate project size — suggest tier change if needed
5. Check if installed skills are still relevant (dependency removed?)
6. Present findings:

```
## Drift Report

**New dependencies detected:**
- drizzle-orm → found skill: bobmatnyc/claude-mpm-skills@drizzle-orm (1.7K installs)

**Removed dependencies:**
- pinia → skill antfu/skills@pinia may no longer be needed

**Size change:**
- Was @small (20 files), now @medium (45 files) → suggest upgrading tier

Apply changes? (y/n)
```

### `/env-craft size @<small|medium|large>`

1. Read `.claude/env-craft.json`
2. Read `${ENV_CRAFT_ROOT}/sizes/<size>.json` for new tier list
3. Re-copy tier rules (remove old, copy new)
4. Update manifest
5. Report changes

### `/env-craft list`

1. Read `.claude/env-craft.json`
2. Display: detected stack, size, active tiers, installed skills, last assembled timestamp

### `/env-craft add <skill-query>`

Search and install additional skills:

1. Run `npx skills find <query>`
2. Present results
3. User picks
4. Install with `npx skills add <package> -a claude-code -y`
5. Update manifest

### `/env-craft remove <skill-name>`

1. Run `npx skills remove <skill-name> -a claude-code -y`
2. Update manifest
3. Report removal

### `/env-craft eject`

1. Skills and rules remain in `.claude/`
2. Remove `.claude/env-craft.json`
3. Rules in `.claude/rules/` are yours to keep or delete
4. Warn: "Environment ejected. Files are now standalone — env-craft commands will no longer work."

## Size Estimation

Count source files (exclude `node_modules`, `.git`, `vendor`, `dist`, `build`):

| Metric | @small | @medium | @large |
|--------|--------|---------|--------|
| Source files | < 30 | 30-100 | > 100 |
| Components/pages | < 15 | 15-50 | > 50 |

## Quality Tiers

Tiers are env-craft's own content — framework-agnostic code quality rules:

| Tier | Applied at | Rules |
|------|-----------|-------|
| **Core** | All sizes | DRY, naming, clean-code, consistency |
| **Structure** | @medium + @large | Folder architecture, separation of concerns, typing |
| **Patterns** | @large only | SOLID, dependency injection, layered architecture |

Tier rules live in `${ENV_CRAFT_ROOT}/tiers/{core,structure,patterns}/rules/`.

## Key Principles

- **Project agnostic** — works with any language, framework, or stack
- **Dynamic discovery** — no hardcoded mappings, search skills.sh in real-time
- **Never auto-apply** — always show what will change and ask for confirmation
- **User chooses** — present options, don't force decisions
- **Transparent** — always report what was added/removed/changed
- **Idempotent** — running init twice produces the same result
