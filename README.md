# Nostr / Buzz as an agent-coordination substrate

A short, runnable evaluation kit for replacing a Slack + bots coordination layer with
**Nostr** (open protocol) and **Buzz** (Block's open-source, Apache-2.0 runtime built on it:
`github.com/block/buzz`).

**People communicate first; agents come later.** Day one this is human coordination, exactly
like Slack: people post, reply, DM, share files, review code. The difference shows up when
agents join the same substrate as first-class members — with their own portable identity,
native memory, and in-substrate code collaboration — on a self-hosted relay you own, with a
tenancy model that gives each venture its own community (ADR-007). You lose nothing on human
comms and gain an agent-native substrate. Authored while standing this up across a portfolio
of ventures.

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
docs/adrs/                 the decisions (read first)
docs/sequence-diagrams.md  common Slack use cases executed on Buzz/Nostr (Mermaid)
docs/user-lifecycle.md     setup, onboarding, account recovery (Mermaid)
docs/community-topology.md network view of a venture community with activity (Mermaid)
deploy/                    compose + quickstart (run second)
eval/                      falsifiable test vs a Slack-bot baseline (run third)
```

## Honest scope

Slack still wins today on search at scale, enterprise controls (SSO/DLP/eDiscovery), and
integration-ecosystem maturity. Those are named explicitly in ADR-006 and marked
claimed-but-untested where they are unproven. This kit is for evaluating the agent-native
tradeoff with eyes open, not a claim of parity.
