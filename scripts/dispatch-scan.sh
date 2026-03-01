#!/bin/bash
# dispatch-scan.sh — scan all inboxes and dispatch roles with pending messages.
# Called by watchexec on any .md file change in docs/inbox/.
# Each role's dispatch runs in background; dispatch.sh handles locking.

for role in backend frontend; do
    INBOX="/workspace/docs/inbox/$role"
    PENDING=$(find "$INBOX" -maxdepth 1 -name "*.md" ! -name "task.md" 2>/dev/null | head -1)
    if [ -n "$PENDING" ]; then
        bash /workspace/claude/scripts/dispatch.sh "$PENDING" &
    fi
done
wait
