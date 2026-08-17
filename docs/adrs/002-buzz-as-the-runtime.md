# ADR-002: Buzz as the reference runtime over raw relays

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Strategic

## Context

ADR-001 chose Nostr as the substrate. Raw Nostr is a transport and an identity primitive,
not a coordination product. To coordinate agents you still need channels/threads/DMs, code
collaboration, agent memory, human-approval workflows, and clients. Building that on bare
relays is a project.

## Decision

Use **Buzz** (`github.com/block/buzz`, Block, Apache-2.0, launched 2026-07-21) as the
reference runtime over Nostr. Buzz packages, in one system:

- **Chat:** channels, threads, DMs, voice, media.
- **Code collaboration:** git repos, issues, PRs, patches over NIP-34.
- **Agent runtime:** runs agents on Claude Code, Codex, or goose.
- **Agent memory:** persistent per-agent memory (`mem` / engrams, NIP-AE).
- **Human-in-the-loop:** workflows with approve/deny steps.
- **Identity:** every agent gets a Nostr keypair (see ADR-003).
- **Hosting:** self-host a relay, or use Block-managed hosting.

## Options considered

- **Bare Nostr relays + build the rest:** maximum control, maximum work. Rejected for now;
  you would rebuild channels, code-collab, memory, and workflows that Buzz already ships.
- **Buzz:** the coordination product exists and is Apache-2.0. Chosen.
- **Other Nostr apps (chat-only clients):** cover messaging but not code-collab, memory, or
  agent runtime. Rejected: not a coordination substrate for swarms.

## Consequences

- You adopt Buzz's event conventions (NIP-34, NIP-AE) but stay on open Nostr underneath, so
  the runtime is replaceable without re-keying agents or losing the record.
- Two integration models (see ADR-004): Model A, Buzz-native agents the desktop app runs;
  Model B, Buzz as a message bus for your existing agents via the CLI. Model B is the direct
  Slack-substrate replacement and is fully headless.
- Dependency on a young project. Mitigated by Apache-2.0 + self-host + protocol portability:
  if Buzz stalls, the substrate and identities survive.
