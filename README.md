# env-craft

Claude Code plugin that makes any project AI-ready. Scans your tech stack, discovers relevant skills from [skills.sh](https://skills.sh), applies quality rules scaled to your project size, and generates a `CLAUDE.md` — all in one command.

## What is this?

env-craft is an **AI environment architect** that works with any language and framework:

1. **Scans** your project — detects language, framework, dependencies, project size
2. **Discovers** relevant skills from [skills.sh](https://skills.sh) — searches dynamically, no hardcoded mappings
3. **Applies** quality tier rules — DRY, SOLID, clean-code patterns scaled by project size
4. **Generates** CLAUDE.md — tech stack, dev commands, project structure, all auto-detected
5. **You choose** — env-craft presents findings and recommendations, you decide what to install

Works with: JavaScript/TypeScript, Python, Rust, Go, Ruby, PHP, Java/Kotlin, Dart/Flutter, C#/.NET, and any project with a dependency file.

## Install

### From GitHub

```bash
# Clone the repo
git clone https://github.com/MrSociety404/claude-env-craft.git

# Use it as a plugin
claude --plugin-dir ./claude-env-craft
```

### Local development / testing

```bash
claude --plugin-dir /path/to/claude-env-craft
```

After installation, run `/env-craft init` in Claude Code.

## Quick Start

```bash
# Scan your project and set up the environment
/env-craft init
```

env-craft will:
1. Detect your stack (e.g., "Nuxt 4 + TypeScript + Tailwind + Drizzle")
2. Search skills.sh for matching skills
3. Show you what it found with install counts
4. Let you pick which skills to install
5. Apply quality rules based on project size
6. Generate a CLAUDE.md

## Commands

| Command | Description |
|---------|-------------|
| `/env-craft init` | Full scan + setup (skills, rules, CLAUDE.md) |
| `/env-craft check` | Drift detection — find new deps, suggest skills |
| `/env-craft size @large` | Change quality tier level |
| `/env-craft add <query>` | Search and install more skills |
| `/env-craft remove <skill>` | Remove an installed skill |
| `/env-craft list` | Show current environment |
| `/env-craft eject` | Stop using env-craft, keep files |

## Quality Tiers

env-craft's own content — framework-agnostic code quality rules that scale with your project:

| Size | Tiers | What you get |
|------|-------|-------------|
| `@small` | Core | DRY, naming, clean code, consistency. No architecture enforcement. |
| `@medium` | Core + Structure | Adds folder architecture, separation of concerns, strict typing. |
| `@large` | Core + Structure + Patterns | Adds SOLID, dependency injection, layered architecture. |

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
│     User decides     │  Never auto-install anything
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  4. Install          │  npx skills add ... -a claude-code -y
│     Skills + Rules   │  Copy tier rules to .claude/rules/
└──────────┬──────────┘
           ▼
┌─────────────────────┐
│  5. Generate         │  CLAUDE.md + .claude/env-craft.json manifest
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
- [ ] Suggest project-specific agents (PR review, testing, deployment)
- [ ] Detect and configure hooks for CI/CD integration
- [ ] Auto-generate `.claude/commands/` for common project tasks
