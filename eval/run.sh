#!/usr/bin/env bash
# Falsifiable eval scaffold: coordination round-trip + durability on a local relay.
# Stub. Wire the marked sections to your relay and your Slack-bot baseline.
set -euo pipefail

TRIALS="${TRIALS:-100}"
CHANNEL="${CHANNEL:-eval}"

echo "== Nostr/Buzz vs Slack-bot baseline =="
echo "trials: $TRIALS  channel: $CHANNEL"
echo

# --- Metric 1: coordination round-trip latency ------------------------------
# TODO: replace the echo stubs with real `buzz messages send/get` calls and a
# Slack Web API post/read. Record wall-clock per trial; compute p50/p95.
echo "[1] coordination round-trip latency (p50/p95) ... TODO wire buzz + slack"

# --- Metric 2: durability / record fidelity ---------------------------------
# TODO: send K messages, `docker compose restart relay`, re-read, count recovered.
echo "[2] durability after relay restart (recovered/K) ... TODO"

# --- Metric 3: identity portability -----------------------------------------
# TODO: re-point one agent key at a second relay; verify signature + attribution.
echo "[3] identity portability (verify across relays) ... TODO (Slack: N/A by design)"

# --- Metric 4: search recall (the untested claim) ---------------------------
# TODO: index M messages, run Q known-answer queries, report recall@10 both sides.
echo "[4] search recall@10 vs Slack ... TODO (this is the claimed-untested cell)"

echo
echo "Report each number against its baseline with p50/p95 or N-per-condition."
echo "A capability is not 'verified' until it beats the baseline."
