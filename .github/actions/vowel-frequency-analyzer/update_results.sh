#!/bin/sh
set -e
RESULTS="$1"; USERNAME="$2"; COUNTS="$3"
{
  echo "# Vowel frequency results"
  echo
  echo "Written by the custom Docker action in \`.github/actions/vowel-frequency-analyzer\`."
  echo
  echo "- Last run by: @$USERNAME"
  echo "- Timestamp (UTC): $(date -u '+%Y-%m-%d %H:%M:%S')"
  echo
  echo '```'
  echo "$COUNTS"
  echo '```'
} > "$RESULTS"
