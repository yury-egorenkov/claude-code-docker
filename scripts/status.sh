#!/bin/bash
# status.sh — show status of all agent inboxes and locks

echo "=== Agent Status ==="
echo

for role in ceo backend frontend; do
    INBOX="/workspace/docs/inbox/$role"
    LOCK="/tmp/claude-role-$role.lock"
    PENDING=$(find "$INBOX" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
    DONE=$(find "$INBOX/done" -name "*.md" 2>/dev/null | wc -l)
    STATUS="idle"
    [ -f "$LOCK" ] && STATUS="RUNNING"
    printf "%-12s pending: %-3s done: %-3s %s\n" "$role" "$PENDING" "$DONE" "$STATUS"
done

echo
echo "=== Lock Files ==="
ls /tmp/claude-role-*.lock 2>/dev/null || echo "None"
