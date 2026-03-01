#!/bin/bash
# dispatch.sh — triggered by watchexec on new inbox file
# Usage: dispatch.sh <changed-file-path>

set -euo pipefail

FILE="$1"
ROLE=$(echo "$FILE" | sed 's|.*/inbox/\([^/]*\)/.*|\1|')

# Skip: processed messages, non-markdown, CEO (interactive), broadcasts, unknown
[[ "$FILE" == */done/* ]]   && exit 0
[[ "$FILE" != *.md ]]       && exit 0
[[ "$ROLE" == "ceo" ]]      && exit 0
[[ "$ROLE" == "all" ]]      && exit 0

LOCKFILE="/tmp/claude-role-$ROLE.lock"
ROLE_CLAUDE="/workspace/claude/roles/$ROLE/CLAUDE.md"
MEMORY_FILE="/workspace/claude/memory/$ROLE/MEMORY.md"
LOG_DIR="/workspace/docs/tracking/logs"

[ ! -f "$ROLE_CLAUDE" ] && echo "No CLAUDE.md for role $ROLE" && exit 0
mkdir -p "$LOG_DIR"

# One process per role — if already running, exit.
# File stays in inbox, will be picked up when current run finishes.
if [ -f "$LOCKFILE" ]; then
    echo "[$(date)] [$ROLE] Locked, skipping (file stays in inbox)" >> "$LOG_DIR/$ROLE.log"
    exit 0
fi

touch "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

# Build memory context
MEMORY_CONTEXT=""
if [ -f "$MEMORY_FILE" ]; then
    MEMORY_CONTEXT="

---
## Your Memory (from previous sessions)
$(cat "$MEMORY_FILE")"
fi

TASK_PROMPT="Check your inbox at /workspace/docs/inbox/$ROLE/ (skip done/ subfolder).
Process ALL pending messages in chronological order (oldest first).
For each message:
1. Read and understand the task
2. Plan the work (create a todo list for non-trivial tasks)
3. Execute the work
4. Write results/response to the sender's inbox if needed
5. Log what was done in /workspace/docs/tracking/logs/$ROLE.log
6. Move the processed message to /workspace/docs/inbox/$ROLE/done/
7. Update /workspace/docs/tracking/sprint.md if applicable
8. Commit code changes to YOUR repo
9. Commit doc changes (inbox, tracking, logs) to /workspace/docs/
After processing all messages, update your memory file at $MEMORY_FILE with any new lessons learned.
$MEMORY_CONTEXT"

# Load bwrap mount profile for this role
BWRAP_PROFILES="/workspace/claude/scripts/bwrap-profiles.sh"
MOUNTS=""
if [ -f "$BWRAP_PROFILES" ]; then
    source "$BWRAP_PROFILES"
    MOUNTS=$(bwrap_mounts_$ROLE 2>/dev/null || echo "")
fi

echo "[$(date)] [$ROLE] Processing inbox (triggered by $FILE)" >> "$LOG_DIR/$ROLE.log"

if [ -n "$MOUNTS" ]; then
    bwrap $MOUNTS \
        -- claude -p "$TASK_PROMPT" \
        --append-system-prompt "$(cat "$ROLE_CLAUDE")" \
        --dangerously-skip-permissions \
        2>&1 | tee -a "$LOG_DIR/$ROLE.log"
else
    claude -p "$TASK_PROMPT" \
        --append-system-prompt "$(cat "$ROLE_CLAUDE")" \
        --dangerously-skip-permissions \
        2>&1 | tee -a "$LOG_DIR/$ROLE.log"
fi

echo "[$(date)] [$ROLE] Done" >> "$LOG_DIR/$ROLE.log"
