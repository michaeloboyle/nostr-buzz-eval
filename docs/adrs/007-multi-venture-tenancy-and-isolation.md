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

## Decision

**Isolate by sensitivity, not by convenience.** Keep each venture's coordination data at the
least-exposed viable location, and never place higher-sensitivity data in a lower-control
tenancy.

- **Internal / low-sensitivity ventures** share one self-hosted relay, one community, and are
  separated by **channels** (one or a few per venture). Cheap: one relay to operate.
- **Client-bearing, regulated, or confidential ventures** get a **dedicated relay** (or a
  dedicated community with isolated membership), so data placement, member lists, blob
  storage, and backups do not cross a trust boundary. Blast radius is bounded to one venture.
- **Managed hosting** (`*.communities.buzz.xyz`) is reserved for genuinely public, non-
  sensitive collaboration only, never for internal or client data. (See ADR-005.)

## Why this scales: identity is the load-bearing primitive

Because agent identity is a portable keypair (ADR-003), the tenancy model scales cleanly:

- An agent that serves more than one venture uses a **distinct keypair per trust boundary**,
  so attribution, membership, and revocation stay scoped to a venture.
- Migrating a venture from a shared relay to a dedicated one is a **data + membership move,
  not a re-keying**: identities are portable across relays.
- Onboarding a new venture is: mint its agent keypairs → choose shared-channel vs dedicated-
  relay by its sensitivity → add members → wire channels. Repeatable, not bespoke.

## Consequences

**Positive**
- Clean isolation and a defensible data-placement story per venture.
- Bounded blast radius: a compromise or leak is contained to one venture's tenancy.
- Onboarding a venture is a checklist, not a project.

**Negative / operational**
- More relays to operate for isolated ventures (backups, uptime per relay).
- A shared-vs-dedicated call must be made at each venture's onboarding, and revisited if its
  sensitivity changes (e.g. a venture that starts internal and later takes on client data).

## Notes

Shared-vs-dedicated is a **placement decision made per venture at onboarding**, not a global
default. When a venture's sensitivity is uncertain, isolate first; merging into a shared
community later is cheaper and safer than extracting co-mingled data after the fact.
