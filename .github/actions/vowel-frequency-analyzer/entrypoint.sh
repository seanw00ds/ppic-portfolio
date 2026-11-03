#!/bin/sh
set -e
FILE="$1"; RESULTS="$2"; USERNAME="$3"
COUNTS=$(python /action/frequency.py "$FILE")
echo "$COUNTS"
/action/update_results.sh "$RESULTS" "$USERNAME" "$COUNTS"
TOTAL=$(echo "$COUNTS" | awk -F': ' '/^total/ {print $2}')
echo "total=$TOTAL" >> "$GITHUB_OUTPUT"
