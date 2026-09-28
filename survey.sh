#!/bin/bash
# survey.sh — measure what the samples in this corpus actually share.
#
# Its subject IS the corpus, so it reads its siblings. It answers one question
# with numbers: across every device in these articles — a microcontroller on a
# USB cable, a board on Wi-Fi, three benchtop instruments, a greenhouse bus, a
# dashcam, a dozen counter apps — how many things draw the screen?
#
# The answer this corpus gives: none of the samples carries a renderer at all.
# Every screen is drawn by the player the reader already has; what a sample
# ships is a server (mcp_server from pub.dev) or a folder of JSON.
set -uo pipefail
cd "$(dirname "$0")/.."
OUT="one-runtime-survey/captures/survey.txt"
mkdir -p one-runtime-survey/captures
: > "$OUT"
{
  echo "what each sample ships, and what draws its screen"
  echo ""
  printf "%-26s %-9s %-9s %-13s %s\n" sample servers bundles runtime_copy mcp_server
  for d in */; do
    s=${d%/}
    [ "$s" = "tools" ] && continue
    servers=$(ls -d "$s"/*_server "$s"/assistant "$s"/bridge_server 2>/dev/null | wc -l | tr -d ' ')
    bundles=$(ls -d "$s"/*.mbd 2>/dev/null | wc -l | tr -d ' ')
    copies=$(ls -d "$s"/vendor 2>/dev/null | wc -l | tr -d ' ')
    ver=$(grep -h '^  mcp_server:' "$s"/*/pubspec.yaml "$s"/pubspec.yaml 2>/dev/null | awk '{print $2}' | sort -u | tr '\n' ' ')
    printf "%-26s %-9s %-9s %-13s %s\n" "$s" "$servers" "$bundles" "$copies" "${ver:--}"
  done
  echo ""
  echo "runtime copies inside the corpus: $(ls -d */vendor 2>/dev/null | wc -l | tr -d ' ')"
  echo "flutter apps inside the corpus: $(grep -l '^  flutter:' */*/pubspec.yaml 2>/dev/null | wc -l | tr -d ' ')"
  echo "the screen is drawn by: AppPlayer (flutter_mcp_ui_runtime, published on pub.dev)"
} | tee -a "$OUT"
