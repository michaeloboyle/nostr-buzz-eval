# Nostr / Buzz as an agent-coordination substrate

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/michaeloboyle/nostr-buzz-eval)

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

Self-host the relay stack (relay + Postgres + Redis + MinIO):

**Click to try:** open this repo in GitHub Codespaces (badge above), then:

```bash
cd deploy && ./quickstart.sh    # generates .env with fresh secrets, brings up the stack
```

Codespaces is for **evaluation** (an in-browser dev container), not a public relay. For a
reachable relay, use the IaC below or a VM.

Prefer infrastructure-as-code? Provision a reachable relay instead of running it locally:

- `deploy/cloud-init.yaml` — provider-neutral bootstrap (installs Docker, brings the stack
  up on any cloud VM or bare host).
- `deploy/terraform/` — a minimal, validated Terraform example (VM + firewall + cloud-init).
  `terraform apply` provisions **billable** resources; see `deploy/terraform/README.md`.

`deploy/` mirrors the upstream `github.com/block/buzz` `deploy/compose` (sanitized: no keys,
IDs, or hostnames from any real environment; secrets are generated locally). Pin the image
tag against upstream before production use.

## After it's running (using Buzz)

Booting the relay is the deploy boundary this kit owns. Day-to-day **client usage is Buzz's**,
so for installing/logging into the Buzz client, sending messages, DMs, and the UI, follow the
upstream docs: **[github.com/block/buzz](https://github.com/block/buzz)**. This repo does not
duplicate client how-to; it would only drift from theirs.

Two operator steps that are deploy-specific, so they live here:

- **Point a client at your relay:** `wss://<host>:3000` (or your tunnel / VM URL).
- **Invite people (relay membership):** add each person or agent by public key —
  ```bash
  docker compose exec relay /usr/local/bin/buzz-admin add-member --pubkey <hex> --role member
  docker compose exec relay /usr/local/bin/buzz-admin list-members
  ```
  Adding several? `sleep 1` between calls (avoids same-second roster-event collisions); never
  add in parallel.

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
deploy/                    compose + quickstart, plus IaC (cloud-init + Terraform)
.devcontainer/             one-click "Open in Codespaces" (click-to-try in browser)
eval/                      falsifiable test vs a Slack-bot baseline (run third)
```

## Honest scope

Slack still wins today on search at scale, enterprise controls (SSO/DLP/eDiscovery), and
integration-ecosystem maturity. Those are named explicitly in ADR-006 and marked
claimed-but-untested where they are unproven. This kit is for evaluating the agent-native
tradeoff with eyes open, not a claim of parity.
