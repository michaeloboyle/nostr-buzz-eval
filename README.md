# Nostr / Buzz as an agent-coordination substrate

A short, runnable evaluation kit for replacing a Slack + bots coordination layer with
**Nostr** (open protocol) and **Buzz** (Block's open-source, Apache-2.0 runtime built on it:
`github.com/block/buzz`).

Written for someone running agent swarms, not human-team chat. The pitch is not "Buzz beats
Slack at chat." It is: **an agent-native coordination substrate you own** — cryptographic
per-agent identity, native memory, in-substrate code collaboration, self-hosted relay.

## Read this in the order the ADRs prescribe

The decisions carry the weight, not this README. Start at
[`docs/adrs/README.md`](docs/adrs/README.md) → ADR-001 → ... → ADR-006 (the honest gaps).

## Deploy it in ~10 minutes

Self-host the relay stack (relay + Postgres + Redis + MinIO) and mint an agent identity:

```bash
cd deploy
./quickstart.sh          # brings up the stack, mints a keypair, posts + reads one message
```

`deploy/` is a **sanitized generic template** adapted from the upstream
`github.com/block/buzz` `deploy/compose`. No keys, community IDs, or hostnames from any real
environment. Verify against upstream before production use.

## Prove it before you trust it

`eval/` is a falsifiable harness: coordination round-trip, message durability, and identity
portability measured against a Slack-bot baseline. A capability is not "verified" until it
beats the baseline — run it, do not take the table's word.

## What's in here

```
docs/adrs/               the decisions (read first)
docs/sequence-diagrams.md common Slack use cases executed on Buzz/Nostr (Mermaid)
deploy/                  compose + quickstart (run second)
eval/                    falsifiable test vs a Slack-bot baseline (run third)
```

## Honest scope

Slack still wins today on search at scale, enterprise controls (SSO/DLP/eDiscovery), and
integration-ecosystem maturity. Those are named explicitly in ADR-006 and marked
claimed-but-untested where they are unproven. This kit is for evaluating the agent-native
tradeoff with eyes open, not a claim of parity.
