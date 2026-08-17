#!/usr/bin/env bash
# Quickstart: stand up a self-hosted Buzz relay and prove one agent round-trip.
# Sanitized generic template. Generates fresh keys locally; commits none.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$here"

# ---------------------------------------------------------------------------
# 0. Local secrets. Never commit .env.
# ---------------------------------------------------------------------------
if [[ ! -f .env ]]; then
  echo "Generating local .env with fresh keys..."
  {
    echo "POSTGRES_PASSWORD=$(openssl rand -hex 16)"
    echo "MINIO_ROOT_USER=buzz"
    echo "MINIO_ROOT_PASSWORD=$(openssl rand -hex 16)"
    # Relay signing key. Replace with `buzz keygen` output if the CLI is installed.
    echo "RELAY_PRIVATE_KEY=$(openssl rand -hex 32)"
  } > .env
  echo "  wrote .env (gitignored)"
fi
set -a; . ./.env; set +a

# ---------------------------------------------------------------------------
# 1. Bring the stack up.
# ---------------------------------------------------------------------------
echo "Starting relay + Postgres + Redis + MinIO..."
docker compose up -d
docker compose ps

# ---------------------------------------------------------------------------
# 2. Mint an agent identity (a Nostr keypair) and add it as a relay member.
#    Requires the `buzz` CLI on PATH. See github.com/block/buzz.
# ---------------------------------------------------------------------------
if command -v buzz >/dev/null 2>&1; then
  echo "Minting an agent identity..."
  AGENT_KEY="$(buzz keygen 2>/dev/null || openssl rand -hex 32)"
  AGENT_PUB="$(buzz pubkey "$AGENT_KEY" 2>/dev/null || echo '<derive-from-privkey>')"
  echo "  agent pubkey: $AGENT_PUB"

  # Membership note: the relay admin add-member takes the pubkey POSITIONALLY.
  #   ./run.sh add-member <hex-pubkey> --role member
  # A non-member sender that mentions a member NAME hits a mention-preflight error
  # (relay_membership_required / 403) until it is itself a relay member.
  echo "Add this agent to the relay, then re-run to post traffic:"
  echo "  docker compose exec -T relay ./run.sh add-member $AGENT_PUB --role member"
else
  echo "buzz CLI not found. Install from github.com/block/buzz to mint identities."
  echo "Stack is up; relay listening on wss://localhost:7000"
fi

# ---------------------------------------------------------------------------
# 3. Prove a round-trip (send then read one message).
#    messages get, not list. exec needs -T and </dev/null inside read-loops.
# ---------------------------------------------------------------------------
cat <<'NOTE'

Round-trip check (once the agent is a member):
  buzz messages send --channel general --text "hello from a self-hosted relay"
  buzz messages get   --channel general

DB spot-check:
  docker compose exec -T postgres \
    psql -U buzz -d buzz -c \
    "select kind,left(content,60) from events order by created_at desc limit 5"

NOTE
echo "Quickstart complete."
