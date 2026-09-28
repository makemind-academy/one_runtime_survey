#!/bin/bash
# The claim under test: the screens in this corpus are drawn by one runtime, the
# player's, and no sample carries a renderer of its own. Copies drift; one does not.
set -uo pipefail
cd "$(dirname "$0")"
bash survey.sh > /dev/null
S="captures/survey.txt"
COPIES=$(awk -F': ' '/runtime copies inside the corpus/ {print $2}' "$S" | tr -d ' ')
APPS=$(awk -F': ' '/flutter apps inside the corpus/ {print $2}' "$S" | tr -d ' ')
[ "$COPIES" = "0" ] || { echo "   $COPIES runtime copies found — a sample carries its own renderer"; exit 1; }
[ "$APPS" = "0" ] || { echo "   $APPS flutter apps found — a sample draws for itself"; exit 1; }
SAMPLES=$(awk 'NR>3 && NF>=4 && $1 !~ /^(runtime|flutter|the)$/ {n++} END{print n+0}' "$S")
[ "$SAMPLES" -ge 30 ] || { echo "   only $SAMPLES samples surveyed"; exit 1; }
MAJORS=$(awk 'NR>3 && NF>=5 && $5 ~ /^\^/ {split($5, v, "."); print v[1]}' "$S" | sort -u | wc -l | tr -d ' ')
[ "$MAJORS" -eq 1 ] || { echo "   the servers span $MAJORS major versions of mcp_server"; exit 1; }
echo "   $SAMPLES samples · 0 runtime copies · 0 flutter apps · one major of mcp_server · one player draws them all"
