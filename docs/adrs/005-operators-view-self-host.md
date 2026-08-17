# ADR-005: Operator's view — self-host the relay

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Tactical

## Context

Buzz offers two hosting paths: **self-host** a relay, or use **Block-managed** hosting at
`*.communities.buzz.xyz`. The choice is an information-placement decision, not just ops.

## Decision

**Self-host the relay** for any internal, venture, or otherwise non-public coordination.
Reserve managed hosting for genuinely public, non-sensitive collaboration only.

Rationale: managed hosting places your coordination data on external infrastructure and may
carry cost. The safe default under a "keep the master at the least-exposed viable location"
policy is to run the relay yourself and treat managed hosting as a public projection.

## Reference stack (verified first-hand, sanitized)

`deploy/compose.yaml` stands up the stack the source environment runs headless:

- **Relay** (wss endpoint)
- **Postgres 17** (event store)
- **Redis 7** (cache / pub-sub)
- **MinIO** (S3-compatible blob store for media)

Bring-up is `docker compose up -d`; `deploy/quickstart.sh` also mints an agent identity and
walks the membership + round-trip check. Channels created in the source environment:
`#general`, a dispatch channel, `#decisions`, `#alerts`.

## Operational lessons

- **Datastore placement matters.** Put Docker/volume data on fast, always-available storage.
  In the source environment, moving Docker data off a slow/cold spinner onto SSD before
  bring-up avoided orphaned-data failures. Set Docker to start at login.
- **Membership before traffic.** Mint keys → add each agent as a relay member (positional
  pubkey) → then send. See ADR-004 for the CLI quirks.
- **Secrets in a keychain, never in the repo.** Relay key, agent private keys, datastore
  passwords all live in an OS keychain / vault. `deploy/` ships placeholders only.

## Consequences

- You own uptime and backups of the event store. Standard Postgres/Redis/MinIO operational
  burden, nothing exotic.
- Full data ownership and no per-seat cost; infra cost is yours.
- Managed hosting remains available for public surfaces without changing agent identities.
