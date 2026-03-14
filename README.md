# env-craft

Claude Code plugin that makes any project AI-ready. Scans your tech stack, discovers relevant skills from [skills.sh](https://skills.sh), applies quality rules scaled to your project size, and generates a `CLAUDE.md` — all in one command.

## What is this?

env-craft is an **AI environment architect** that works with any language and framework:

1. **Scans** your project — detects language, framework, dependencies, project size
2. **Discovers** tech skills from [skills.sh](https://skills.sh) — searches dynamically, no hardcoded mappings
3. **Suggests** workflow skills — brainstorming, planning, git workflows, debugging (from [obra/superpowers](https://skills.sh/obra/superpowers) and others)
4. **Applies** quality tier rules — DRY, SOLID, clean-code patterns scaled by project size
5. **Generates** CLAUDE.md — tech stack, dev commands, project structure, all auto-detected
6. **You choose** — env-craft presents findings and recommendations, you decide what to install

Works with: JavaScript/TypeScript, Python, Rust, Go, Ruby, PHP, Java/Kotlin, Dart/Flutter, C#/.NET, and any project with a dependency file.

## Install

### Option 1: Clone and add as plugin

```bash
git clone https://github.com/MrSociety404/claude-env-craft.git ~/.claude/plugins/env-craft
```

Then add to your Claude Code settings (`.claude/settings.json`):

```json
{
  "plugins": ["~/.claude/plugins/env-craft"]
}
```

### Option 2: Per-session

```bash
claude --plugin-dir /Users/fabrice/cloud/perso/claude-env-craft/src
```

After installation, run `/env-craft init` in Claude Code.

## Quick Start

```bash
# Scan your project and set up the environment
/env-craft init
```

env-craft will:

1. Detect your stack (e.g., "Nuxt 4 + TypeScript + Tailwind + Drizzle")
2. **Phase 1 — Tech skills:** Search skills.sh for stack-specific skills, show results, let you pick
3. **Phase 2 — Workflow skills:** Suggest developer workflow tools (brainstorming, planning, git, debugging) — install all or pick categories
4. Apply quality rules based on project size
5. Generate a CLAUDE.md
6. Store everything in `.agents/` with symlinks from `.claude/`

## Commands

| Command                     | Description                                     |
| --------------------------- | ----------------------------------------------- |
| `/env-craft init`           | Full scan + setup (skills, rules, CLAUDE.md)    |
| `/env-craft check`          | Drift detection — find new deps, suggest skills |
| `/env-craft size @large`    | Change quality tier level                       |
| `/env-craft add <query>`    | Search and install more skills                  |
| `/env-craft remove <skill>` | Remove an installed skill                       |
| `/env-craft list`           | Show current environment                        |
| `/env-craft eject`          | Stop using env-craft, keep files                |

## Quality Tiers

env-craft's own content — framework-agnostic code quality rules that scale with your project:

| Size      | Tiers                       | What you get                                                       |
| --------- | --------------------------- | ------------------------------------------------------------------ |
| `@small`  | Core                        | DRY, naming, clean code, consistency. No architecture enforcement. |
| `@medium` | Core + Structure            | Adds folder architecture, separation of concerns, strict typing.   |
| `@large`  | Core + Structure + Patterns | Adds SOLID, dependency injection, layered architecture.            |

`@small` is not "fewer rules" — it's **quality without ceremony**. You still get DRY and clean code. You just don't get forced into service layers for a 10-file project.

## How It Works

```
/env-craft init
     │
     ▼
┌─────────────────────┐
│  1. Scan Project     │  Read package.json, pyproject.toml, Cargo.toml, etc.
│     Detect stack     │  Count files, detect framework, estimate size
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  2. Search skills.sh │  npx skills find <dependency> for each major dep
│     Discover skills  │  Rank by install count, filter relevant ones
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  3. Present & Choose │  Show findings table, user picks what to install
│     Tech skills      │  Never auto-install anything
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  4. Workflow Skills  │  Suggest brainstorming, planning, git, debugging
│     Choose category  │  all / git / planning / creative / quality / skip
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  5. Install          │  npx skills add ... -a claude-code -y
│     Skills + Rules   │  Everything in .agents/ with .claude/ symlinks
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  6. Generate         │  CLAUDE.md + .claude/env-craft.json manifest
│     CLAUDE.md        │  Full project context for Claude
└─────────────────────┘
```

## Plugin Structure

```
env-craft/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── skills/
│   └── env-craft/
│       └── SKILL.md        # The orchestrator (all the logic)
├── commands/               # Bundled commands (installed during init)
│   ├── commit.md           # /commit — conventional commits
│   ├── create-branch.md    # /create-branch — conventional branch names
│   ├── create-pr.md        # /create-pr — commit + push + PR
│   ├── create-branch-pr.md # /create-branch-pr — branch + commit + PR
│   └── review-pr.md        # /review-pr — code review with GitHub API
├── tiers/                  # Quality rules (env-craft's own content)
│   ├── core/rules/         # DRY, naming, clean-code, consistency
│   ├── structure/rules/    # Folder architecture, typing, SoC
│   └── patterns/rules/     # SOLID, DI, layered architecture
├── sizes/                  # Size → tier mappings
│   ├── small.json
│   ├── medium.json
│   └── large.json
└── README.md
```

## Roadmap

- [ ] Publish to official Claude plugin marketplace
- [ ] Skills cache to avoid repeated searches
- [ ] Detect and configure hooks for CI/CD integration
- [ ] Auto-generate `.claude/commands/` for common project tasks
- [ ] Custom rule generation from code analysis (Vision B)
