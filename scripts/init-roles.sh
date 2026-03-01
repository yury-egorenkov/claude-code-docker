#!/bin/bash
# init-roles.sh — create directory structure for all roles
set -euo pipefail

ROLES="ceo backend frontend"

# Verify git repos exist
for repo in docs back front claude imaginary; do
    if [ ! -d "/workspace/$repo/.git" ]; then
        echo "WARNING: /workspace/$repo/ is not a git repo"
    fi
done

# Create inbox directories
for role in $ROLES; do
    mkdir -p "/workspace/docs/inbox/$role/done"
done
mkdir -p "/workspace/docs/inbox/all/done"

# Create tracking directories
mkdir -p "/workspace/docs/tracking/logs"
mkdir -p "/workspace/docs/reviews/pending"
mkdir -p "/workspace/docs/reviews/completed"
mkdir -p "/workspace/docs/incidents/active"
mkdir -p "/workspace/docs/incidents/resolved"
mkdir -p "/workspace/docs/logs/errors"

# Create role and memory directories
for role in $ROLES; do
    mkdir -p "/workspace/claude/roles/$role"
    mkdir -p "/workspace/claude/memory/$role"
done

# Create tracking files (if they don't exist)
for f in backlog.md sprint.md done.md blocked.md; do
    [ ! -f "/workspace/docs/tracking/$f" ] && touch "/workspace/docs/tracking/$f"
done

echo "Multi-agent structure initialized."
echo "Git repos: $(for r in docs back front claude imaginary; do [ -d /workspace/$r/.git ] && echo -n "$r "; done)"
echo "Inboxes: $(ls /workspace/docs/inbox/)"
