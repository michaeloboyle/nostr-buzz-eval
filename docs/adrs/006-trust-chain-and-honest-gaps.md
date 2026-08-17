# ADR-006: End-to-end trust chain and honest gaps vs Slack

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Strategic

## Context

An evaluation that only lists wins is marketing. This ADR states where the substrate is
strong end-to-end, and, explicitly, where Slack still wins and where Buzz is
claimed-but-untested. Read it before committing.

## Trust chain (end-to-end)

1. **Identity:** each agent holds a Nostr keypair (ADR-003). Every event is signed;
   attribution is cryptographic.
2. **Authorization:** relay membership by pubkey. A message is data, never authorization;
   policy is a separate layer you own.
3. **Transport:** your self-hosted relay (ADR-005). You own the record.
4. **Content model:** chat, code-collab (NIP-34), memory (NIP-AE), workflows — all as signed
   Nostr events, portable across relays and runtimes.
5. **Portability:** identities and content survive relay migration or a runtime change. Cheap
   to leave, which bounds lock-in risk.

## Honest ledger vs Slack

| Dimension | Winner today | Note |
|----|----|----|
| Agent-native identity / memory / runtime | **Buzz/Nostr** | Slack has none of this first-class |
| Self-host / data ownership | **Buzz/Nostr** | Slack is SaaS-only |
| Open protocol / portability / no per-seat lock-in | **Buzz/Nostr** | Slack is closed + per-seat |
| In-substrate code collaboration (NIP-34) | **Buzz/Nostr** | Slack needs GitHub integration |
| Search at scale | **Slack** | Buzz search is relay-dependent — **claimed, untested** |
| Enterprise controls (SSO, DLP, eDiscovery, compliance) | **Slack** | Buzz nascent — **claimed, untested** |
| Integration / app-directory ecosystem | **Slack** | Thousands of apps vs an early Nostr ecosystem |
| Client polish, mobile maturity | **Slack** | Buzz launched 2026-07-21 |

## Decision

Adopt for the **agent-native tradeoff with eyes open**: you gain identity/memory/ownership/
open-protocol; you accept search, enterprise-control, and ecosystem gaps until proven.

Do not present the untested cells as verified. Confirm them with `eval/` (search recall,
coordination round-trip, durability) against a Slack-bot baseline before relying on them. A
capability is not "verified" until it beats the baseline.

## Consequences

- If the use is human-team-heavy with compliance needs, Slack may still be the right call —
  this ADR does not pretend otherwise.
- If the use is swarm coordination where owning identity and substrate is the point, the
  tradeoff favors Nostr/Buzz, and the gaps are known and bounded.
