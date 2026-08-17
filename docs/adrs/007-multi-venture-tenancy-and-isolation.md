# ADR-007: Multi-venture tenancy and isolation

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Strategic

## Context

The substrate is not for one team; it runs across a **portfolio of ventures**. Ventures sit
at different trust levels: internal/personal work, public collaboration, and
client-bearing or otherwise confidential work. A single shared community is the simplest
thing to stand up, but it co-mingles data, membership, and backups across trust boundaries
that should not touch. Portfolio scale forces a tenancy decision the single-team case never
raises.

Two axes, kept separate:
- **Community** — the tenancy boundary (membership, channels, record).
- **Relay** — where a community is hosted (the data-placement boundary).

## Decision

**One community per venture. Always.** The community is the unit of isolation: each venture
gets its own community, its own membership list, and its own channels. Ventures are never
separated only by channels inside a shared community. This is uniform and non-negotiable, so
tenancy is predictable and a venture's blast radius is always exactly one community.

**Relay placement is then chosen by sensitivity:**
- **Internal / low-sensitivity venture-communities** may share one self-hosted relay (one
  relay hosting several per-venture communities). Cheap to operate; isolation still holds at
  the community boundary.
- **Client-bearing, regulated, or confidential venture-communities** get a **dedicated
  relay**, so data placement, blob storage, and backups do not share infrastructure across a
  trust boundary.
- **Managed hosting** (`*.communities.buzz.xyz`) is reserved for genuinely public, non-
  sensitive communities only, never for internal or client data. (See ADR-005.)

## Why this scales: identity is the load-bearing primitive

Because agent identity is a portable keypair (ADR-003), the model scales cleanly:

- An agent that serves more than one venture uses a **distinct keypair per venture-
  community**, so attribution, membership, and revocation stay scoped to one venture.
- Moving a venture-community from a shared relay to a dedicated one is a **data + membership
  move, not a re-keying**: identities are portable across relays.
- Onboarding a venture is a fixed checklist: create its community → mint its agent keypairs →
  choose shared-relay vs dedicated-relay by sensitivity → add members → wire channels.

## Consequences

**Positive**
- Uniform, predictable isolation: one venture equals one community, no exceptions to reason
  about.
- Bounded blast radius: a compromise or leak is contained to a single venture-community.
- Onboarding a venture is a checklist, not a bespoke design each time.

**Negative / operational**
- More communities to administer than a single shared one (membership per venture).
- A shared-relay vs dedicated-relay call must still be made per venture at onboarding, and
  revisited if a venture's sensitivity changes (e.g. an internal venture later takes on
  client data — move its community to a dedicated relay, no re-keying).

## Notes

Community-per-venture is fixed; relay placement is the only per-venture decision, made at
onboarding by sensitivity. When sensitivity is uncertain, place the community on a dedicated
relay first; consolidating onto a shared relay later is cheaper and safer than extracting
co-mingled data after the fact.
