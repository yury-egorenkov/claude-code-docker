#!/bin/bash
# bwrap-profiles.sh — per-role bubblewrap mount configurations
# Each function returns bwrap arguments for filesystem isolation.
# --bind = read-write, --ro-bind = read-only
# Unmounted paths do not exist inside the sandbox.

bwrap_mounts_backend() {
    echo "\
        --bind /workspace/back             /workspace/back \
        --ro-bind /workspace/docs/guidelines /workspace/docs/guidelines \
        --ro-bind /workspace/docs/features /workspace/docs/features \
        --ro-bind /workspace/docs/agents.md /workspace/docs/agents.md \
        --bind /workspace/docs/inbox/backend /workspace/docs/inbox/backend \
        --bind /workspace/docs/inbox/frontend /workspace/docs/inbox/frontend \
        --bind /workspace/docs/tracking    /workspace/docs/tracking \
        --bind /workspace/claude/memory/backend /workspace/claude/memory/backend \
        --dev /dev --proc /proc"
}

bwrap_mounts_frontend() {
    echo "\
        --bind /workspace/front            /workspace/front \
        --ro-bind /workspace/docs/guidelines /workspace/docs/guidelines \
        --ro-bind /workspace/docs/features /workspace/docs/features \
        --ro-bind /workspace/docs/agents.md /workspace/docs/agents.md \
        --bind /workspace/docs/inbox/frontend /workspace/docs/inbox/frontend \
        --bind /workspace/docs/inbox/backend /workspace/docs/inbox/backend \
        --bind /workspace/docs/tracking    /workspace/docs/tracking \
        --bind /workspace/claude/memory/frontend /workspace/claude/memory/frontend \
        --dev /dev --proc /proc"
}
