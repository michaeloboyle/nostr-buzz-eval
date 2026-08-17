#!/usr/bin/env bash
# Quickstart: generate .env with fresh secrets and bring up a self-hosted Buzz relay.
# Generates keys locally; commits none. Mirrors the upstream env contract.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$here"

# ---------------------------------------------------------------------------
# 1. Local secrets. Never commit .env.
# ---------------------------------------------------------------------------
if [[ ! -f .env ]]; then
  echo "Generating .env with fresh secrets..."
  cat > .env <<EOF
BUZZ_IMAGE=ghcr.io/block/buzz:main
# Placeholder owner pubkey so the stack boots. Replace with YOUR Buzz client's
# public key (64-hex) to actually own the relay. See ADR-003 / ADR-008.
RELAY_OWNER_PUBKEY=$(openssl rand -hex 32)
BUZZ_REQUIRE_AUTH_TOKEN=true
BUZZ_REQUIRE_RELAY_MEMBERSHIP=true
BUZZ_ALLOW_NIP_OA_AUTH=true
BUZZ_AUTO_MIGRATE=true
BUZZ_RELAY_PRIVATE_KEY=$(openssl rand -hex 32)
BUZZ_GIT_HOOK_HMAC_SECRET=$(openssl rand -hex 32)
POSTGRES_DB=buzz
POSTGRES_USER=buzz
POSTGRES_PASSWORD=$(openssl rand -hex 16)
REDIS_PASSWORD=$(openssl rand -hex 16)
BUZZ_S3_ACCESS_KEY=buzz
BUZZ_S3_SECRET_KEY=$(openssl rand -hex 16)
BUZZ_S3_BUCKET=buzz-media
BUZZ_S3_ADDRESSING_STYLE=path
BUZZ_HTTP_PORT=3000
EOF
  chmod 600 .env
  echo "  wrote .env (gitignored). Replace RELAY_OWNER_PUBKEY with your client pubkey to own the relay."
fi

# ---------------------------------------------------------------------------
# 2. Bring the stack up.
# ---------------------------------------------------------------------------
echo "Starting relay + Postgres + Redis + MinIO..."
docker compose --env-file .env up -d --wait || docker compose --env-file .env up -d
docker compose ps

# ---------------------------------------------------------------------------
# 3. Relay membership + round-trip.
#    Add a member (pubkey is POSITIONAL to buzz-admin via the relay container):
#      docker compose exec relay /usr/local/bin/buzz-admin add-member --pubkey <hex> --role member
#      docker compose exec relay /usr/local/bin/buzz-admin list-members
#    When adding several members in a loop, sleep 1 between calls (avoids same-second
#    roster event collisions); never add in parallel.
# ---------------------------------------------------------------------------
cat <<'NOTE'

Relay is on http/ws port 3000 -> wss://<host>:3000

DB spot-check:
  docker compose exec -T postgres psql -U buzz -d buzz -c \
    "select kind,left(content,60) from events order by created_at desc limit 5"

NOTE
echo "Quickstart complete."
