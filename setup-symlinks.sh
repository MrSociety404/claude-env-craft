#!/bin/bash
# env-craft symlink setup
# Creates .claude/ → src/ symlinks for Claude Code to discover rules/skills/agents

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$PROJECT_ROOT/.claude"

mkdir -p "$CLAUDE_DIR"

# Rules and agents: symlink entire directories
# (if they already exist as dirs, remove them first)
for dir in rules agents; do
  if [ -d "$CLAUDE_DIR/$dir" ] && [ ! -L "$CLAUDE_DIR/$dir" ]; then
    rm -rf "$CLAUDE_DIR/$dir"
  fi
  ln -sfn "../src/$dir" "$CLAUDE_DIR/$dir"
  echo "  .claude/$dir → src/$dir"
done

# Skills: .claude/skills/ may already contain other skills (symlinks to .agents/)
# So we create per-skill symlinks instead of replacing the whole directory
mkdir -p "$CLAUDE_DIR/skills"
SRC_SKILLS="$PROJECT_ROOT/src/skills"
for skill_dir in "$SRC_SKILLS"/*/; do
  skill_name="$(basename "$skill_dir")"
  if [ "$skill_name" = "*" ]; then continue; fi
  ln -sfn "../../src/skills/$skill_name" "$CLAUDE_DIR/skills/$skill_name"
  echo "  .claude/skills/$skill_name → src/skills/$skill_name"
done

echo ""
echo "Symlinks created successfully."
