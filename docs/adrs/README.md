# ADRs — Nostr / Buzz as an Agent-Coordination Substrate

These records are the load-bearing content of this repo. The top-level `README.md` is
positioning; the decisions live here. Several are `Proposed` and design-only: the
contract *is* the deliverable, no code required to evaluate it.

## Status snapshot

| ADR | Title | Status | Tier |
|----|----|----|----|
| [001](001-adopt-nostr-coordination-substrate.md) | Adopt Nostr as the agent-coordination substrate | Proposed | Strategic (project shape) |
| [002](002-buzz-as-the-runtime.md) | Buzz as the reference runtime over raw relays | Proposed | Strategic |
| [003](003-agent-identity-and-portability.md) | Cryptographic agent identity, portable across Nostr | Proposed | Strategic |
| [004](004-how-agents-reach-the-relay.md) | How agents reach the substrate (NIP-34, engrams, ACP) | Proposed | Tactical |
| [005](005-operators-view-self-host.md) | Operator's view: self-host the relay | Proposed | Tactical |
| [006](006-trust-chain-and-honest-gaps.md) | End-to-end trust chain and honest gaps vs Slack | Proposed | Strategic |
| [007](007-multi-venture-tenancy-and-isolation.md) | Multi-venture tenancy and isolation | Proposed | Strategic |
| [008](008-identity-lifecycle-and-recovery.md) | Identity lifecycle and account recovery | Proposed | Strategic |

## Prescribed reading order

1. **001** — the decision and why (project shape). Start here.
2. **002** — what Buzz is and why it, not raw Nostr or a bot layer.
3. **003** — the part that matters for swarms: agent identity you own and can port.
4. **004** — how agents actually talk to it (code collab, memory, runtime bridge).
5. **005** — stand it up yourself; verified first-hand, sanitized template in `deploy/`.
6. **006** — the honest ledger: where Slack still wins, what is claimed-but-untested.
7. **007** — running it across a portfolio: one community per venture, relay placement by sensitivity.
8. **008** — identity lifecycle and account recovery: the honest cost of holding your own key.

Read 006 before deciding. It names the gaps on purpose; a one-sided ADR set is marketing.

See also (Mermaid diagrams):
- [`../sequence-diagrams.md`](../sequence-diagrams.md): common Slack workflows executed on the
  substrate, people-first (channel post, thread, DM, approval, code review, file share,
  portable identity).
- [`../user-lifecycle.md`](../user-lifecycle.md): setup, onboarding, and account recovery
  (pairs with ADR-008).
- [`../community-topology.md`](../community-topology.md): a network view of one venture
  community with activity.

## Provenance

Authored from a working self-hosted Buzz deployment (relay + Postgres + Redis + MinIO,
headless, real threaded agent traffic verified). Deploy material in `deploy/` is a
sanitized generic template, no keys, IDs, or hostnames from the source environment.
Falsifiable evaluation harness in `eval/`.
