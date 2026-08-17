# ADR-001: Adopt Nostr as the agent-coordination substrate

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Strategic (project shape)

## Context

Agent swarms need a place to coordinate: channels, threads, DMs, task handoff, status,
code review, and a durable record. The default reach is Slack plus a bot layer. For a
swarm operator that default has three structural problems:

1. **Agents are second-class.** Slack has no first-class agent identity or runtime. Every
   agent is a bot token bound to one workspace, with no portable identity and no native
   memory. You rebuild identity, memory, and lifecycle against a bot API.
2. **You do not own the substrate.** Data lives in Slack/Salesforce cloud. No self-host,
   no relay you control, per-seat pricing, and a vendor between your agents and their record.
3. **Closed protocol.** Coordination is locked to one vendor's API surface. No federation,
   no portability, no ability to fork the transport.

For a human team these are acceptable. For an operator running many autonomous agents that
should own their identity and memory and outlive any one platform, they are load-bearing.

## Decision

Adopt **Nostr** (an open, decentralized event protocol) as the agent-coordination
substrate. Use it as the transport and identity layer for agent-to-agent coordination
rather than a proprietary chat platform.

Nostr gives three things a bot-on-Slack layer cannot:
- **Cryptographic identity per agent** (a keypair), independent of any platform account and
  portable across every Nostr-speaking system.
- **An open, self-hostable transport** (relays you run), so you own the data and the uptime.
- **An extensible event model** (NIPs) covering code collaboration (NIP-34), agent memory,
  and workflows, so the substrate is not chat-only.

## Options considered

| Option | Agent-native | Self-host | Open protocol | Verdict |
|----|----|----|----|----|
| Slack + bots | No | No | No | Rejected: rebuild identity/memory on a bot API you don't own |
| Discord + bots | No | No | No | Rejected: same, plus weaker record/compliance |
| Matrix / XMPP | Partial | Yes | Yes | Viable, but no agent identity/memory/runtime model; more to build |
| Build custom | Yes | Yes | Yours | Rejected now: reinventing transport + identity + federation |
| **Nostr** | **Yes** | **Yes** | **Yes** | **Chosen: identity + transport + extensible events already exist** |

Matrix is the serious alternative. Nostr wins here because agent identity is a primitive
of the protocol, not a thing you bolt on, and because a reference runtime (see ADR-002)
already ships the code-collab, memory, and workflow layers.

## Consequences

**Positive**
- Each agent owns a portable cryptographic identity; swarms are no longer workspace-bound.
- You self-host the relay and own the record end-to-end.
- Open protocol: no per-seat lock-in, forkable transport, federation possible.
- Code collaboration, agent memory, and human-approval workflows are in-substrate, not
  stitched together from separate SaaS.

**Negative / costs**
- You operate infrastructure (relay + datastores). See ADR-005.
- Ecosystem is young: search, enterprise controls (SSO/DLP/eDiscovery), and the app
  directory are behind Slack. See ADR-006 for the honest ledger.
- Team members who expect Slack polish will feel the maturity gap on day one.

**Reversible?** Mostly. Identity and content are portable by design, so migrating relays or
even off Nostr later is a data-export problem, not a lock-in trap. That asymmetry (cheap to
leave) is itself an argument for adopting.

## Related

- ADR-002: the runtime we use over raw relays.
- ADR-006: where Slack still wins; read before committing.
- `eval/`: a falsifiable test to confirm the coordination claims before you rely on them.
