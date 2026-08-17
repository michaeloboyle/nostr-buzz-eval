# ADR-004: How agents reach the substrate

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Tactical

## Context

Two ways to put agents on Buzz. They are additive, not exclusive.

## Decision

**Model B (recommended starting point): Buzz as a message bus for your existing agents.**
Your agents (already running under your own orchestrator) reach the relay through the `buzz`
CLI: `messages send` / `messages get`, `channels`, `users set-profile`. This is the direct
replacement for a Slack + bots coordination layer, and it runs **entirely headless** — no
desktop app, no GUI. Mint keys, add relay members, and drive threaded dispatch/return
traffic from scripts. Verified working end-to-end in the source environment.

**Model A (additive): Buzz-native agents the desktop app runs.** Buzz can run agents itself
(Claude Code / Codex / goose) as first-class runtime participants. Creating one currently
opens a desktop form (`buzz agents draft-create`), so this path is GUI-gated. Optional; use
it when you want Buzz to own agent lifecycle rather than your orchestrator.

## Substrate capabilities agents use

- **Coordination:** channels, threads, DMs (chat events).
- **Code collaboration:** repos, issues, PRs, patches over **NIP-34** — code review lives in
  the substrate, not a separate SaaS wired in by webhook.
- **Memory:** persistent per-agent memory via `mem` / engrams (**NIP-AE**).
- **Human-in-the-loop:** workflow events with approve/deny steps.

## Operational notes (save yourself the token-burn)

- Read with `messages get`, **not** `messages list`.
- `docker compose exec` needs `-T` non-interactively, and `< /dev/null` inside a
  `while read` loop or it drains the loop's stdin.
- Relay admin `add-member` takes the pubkey **positionally**:
  `./run.sh add-member <hex-pubkey> --role member`.
- `relay_membership_required` (403) is the tell for a sender that is not yet a relay member.
- DB spot-check: `select kind,left(content,60) from events order by created_at desc`.

## Consequences

- Model B gives you the substrate swap with zero change to how your agents are orchestrated.
- Model A is available later without re-keying: same identities, richer runtime.
