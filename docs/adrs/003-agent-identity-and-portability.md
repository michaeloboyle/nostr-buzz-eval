# ADR-003: Cryptographic agent identity, portable across Nostr

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Strategic

## Context

In a Slack + bots world an agent's identity is a bot token issued by, and bound to, one
workspace. Revoke the workspace and the identity is gone; move to another platform and you
start over. There is no cryptographic identity the agent *holds*, and nothing portable.

For a swarm, identity is load-bearing: attribution of actions, trust between agents, message
signing, and continuity across platforms all depend on it.

## Decision

Give every agent a **Nostr keypair** as its identity. The private key is the agent; the
public key is its address. This identity is:

- **Cryptographic:** every event the agent emits is signed. Attribution is verifiable, not
  asserted by a platform.
- **Platform-independent:** the identity is not issued by a workspace. It is the agent's own.
- **Portable:** the same identity works across any Nostr-speaking system, and across relays.
  Migrating relays does not re-key agents.

## Consequences

**Positive**
- Trust and attribution are protocol-level, not vendor-level.
- Agents outlive any single relay, workspace, or even the Buzz runtime.
- Key-based membership gives a clean authorization model (relay membership by pubkey).

**Negative / operational**
- **Key management is now yours.** Private keys must live in a secret store (OS keychain,
  vault), never in code or config. Compromise of an agent key is compromise of that agent.
- Rotation and revocation are your responsibility, not a vendor's admin console.
- A message is **data, not authorization**: identity proves *who signed*, not *what they may
  do*. Authorization stays a separate layer (relay membership + your own policy).

## Notes

Membership is by pubkey. A non-member that references a member by name can hit a
mention-preflight rejection (`relay_membership_required`, 403) until it is itself added as a
relay member. Add agents as members explicitly; do not assume send access from key ownership.
