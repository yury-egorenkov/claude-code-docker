#!/bin/bash
# bwrap-profiles.sh — per-role bubblewrap mount configurations
# Each function returns bwrap arguments for filesystem isolation.
# --bind = read-write, --ro-bind = read-only
# Unmounted paths do not exist inside the sandbox.

bwrap_mounts_cto() {
    echo "\
        --ro-bind /workspace/back          /workspace/back \
        --ro-bind /workspace/front         /workspace/front \
        --ro-bind /workspace/imaginary     /workspace/imaginary \
        --bind /workspace/claude           /workspace/claude \
        --ro-bind /workspace/docs          /workspace/docs \
        --bind /workspace/docs/inbox/cto   /workspace/docs/inbox/cto \
        --bind /workspace/docs/inbox/backend /workspace/docs/inbox/backend \
        --bind /workspace/docs/inbox/frontend /workspace/docs/inbox/frontend \
        --bind /workspace/docs/inbox/qa    /workspace/docs/inbox/qa \
        --bind /workspace/docs/tracking    /workspace/docs/tracking \
        --bind /workspace/docs/reviews     /workspace/docs/reviews \
        --bind /workspace/docs/decisions.md /workspace/docs/decisions.md \
        --bind /workspace/claude/memory/cto /workspace/claude/memory/cto \
        --dev /dev --proc /proc"
}

bwrap_mounts_pm() {
    echo "\
        --ro-bind /workspace/docs          /workspace/docs \
        --bind /workspace/docs/inbox       /workspace/docs/inbox \
        --bind /workspace/docs/tracking    /workspace/docs/tracking \
        --bind /workspace/claude/memory/pm /workspace/claude/memory/pm \
        --dev /dev --proc /proc"
}

bwrap_mounts_backend() {
    echo "\
        --bind /workspace/back             /workspace/back \
        --ro-bind /workspace/docs/guidelines /workspace/docs/guidelines \
        --ro-bind /workspace/docs/features /workspace/docs/features \
        --ro-bind /workspace/docs/agents.md /workspace/docs/agents.md \
        --bind /workspace/docs/inbox/backend /workspace/docs/inbox/backend \
        --bind /workspace/docs/inbox/qa    /workspace/docs/inbox/qa \
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
        --bind /workspace/docs/inbox/qa    /workspace/docs/inbox/qa \
        --bind /workspace/docs/tracking    /workspace/docs/tracking \
        --bind /workspace/claude/memory/frontend /workspace/claude/memory/frontend \
        --dev /dev --proc /proc"
}

bwrap_mounts_qa() {
    echo "\
        --ro-bind /workspace/back          /workspace/back \
        --ro-bind /workspace/front         /workspace/front \
        --ro-bind /workspace/docs          /workspace/docs \
        --bind /workspace/docs/reviews     /workspace/docs/reviews \
        --bind /workspace/docs/inbox/qa    /workspace/docs/inbox/qa \
        --bind /workspace/docs/inbox/backend /workspace/docs/inbox/backend \
        --bind /workspace/docs/inbox/frontend /workspace/docs/inbox/frontend \
        --bind /workspace/docs/inbox/cto   /workspace/docs/inbox/cto \
        --bind /workspace/docs/tracking    /workspace/docs/tracking \
        --bind /workspace/claude/memory/qa /workspace/claude/memory/qa \
        --dev /dev --proc /proc"
}

bwrap_mounts_marketing() {
    echo "\
        --bind /workspace/docs/management  /workspace/docs/management \
        --bind /workspace/docs/inbox/marketing /workspace/docs/inbox/marketing \
        --ro-bind /workspace/docs/agents.md /workspace/docs/agents.md \
        --bind /workspace/claude/memory/marketing /workspace/claude/memory/marketing \
        --dev /dev --proc /proc"
}

bwrap_mounts_designer() {
    echo "\
        --bind /workspace/front/static/images /workspace/front/static/images \
        --bind /workspace/docs/inbox/designer /workspace/docs/inbox/designer \
        --ro-bind /workspace/docs/agents.md /workspace/docs/agents.md \
        --ro-bind /workspace/docs/management /workspace/docs/management \
        --bind /workspace/claude/memory/designer /workspace/claude/memory/designer \
        --dev /dev --proc /proc"
}

bwrap_mounts_video() {
    echo "\
        --bind /workspace/docs/inbox/video /workspace/docs/inbox/video \
        --ro-bind /workspace/docs/management /workspace/docs/management \
        --bind /workspace/claude/memory/video /workspace/claude/memory/video \
        --dev /dev --proc /proc"
}

bwrap_mounts_support() {
    echo "\
        --bind /workspace/docs/inbox       /workspace/docs/inbox \
        --bind /workspace/docs/incidents   /workspace/docs/incidents \
        --ro-bind /workspace/docs/tracking /workspace/docs/tracking \
        --ro-bind /workspace/docs/features /workspace/docs/features \
        --bind /workspace/claude/memory/support /workspace/claude/memory/support \
        --dev /dev --proc /proc"
}

bwrap_mounts_debops() {
    echo "\
        --ro-bind /workspace/back          /workspace/back \
        --ro-bind /workspace/front         /workspace/front \
        --bind /workspace/docs/inbox/debops /workspace/docs/inbox/debops \
        --bind /workspace/docs/inbox/backend /workspace/docs/inbox/backend \
        --bind /workspace/docs/inbox/cto   /workspace/docs/inbox/cto \
        --bind /workspace/docs/incidents   /workspace/docs/incidents \
        --bind /workspace/docs/logs        /workspace/docs/logs \
        --ro-bind /workspace/docs/tracking /workspace/docs/tracking \
        --bind /workspace/claude/memory/debops /workspace/claude/memory/debops \
        --dev /dev --proc /proc"
}
