# Falsifiable evaluation harness

A capability is not "verified" until it beats a baseline. This harness measures the claims in
the ADRs against a **Slack-bot baseline**, so adoption rests on evidence, not the table.

## Baseline

A minimal Slack + bot coordination loop: a bot posts to a channel, a second bot reads and
replies in-thread, a third records to an external store. Measure the same three things there.

## Metrics (each vs the Slack-bot baseline)

1. **Coordination round-trip latency.** Agent A posts a task → Agent B reads, acts, replies
   in-thread → A observes the reply. Report p50/p95 over N=100 trials, both systems.
2. **Durability / record fidelity.** Post K messages, restart the relay (and the Slack bot
   host), re-read. Report messages recovered / K. Nostr target: 100% from the event store.
3. **Identity portability.** Take one agent identity, point it at a second relay, re-send.
   Confirm signature verifies and attribution is preserved. Slack baseline: not possible
   (identity is workspace-bound) — record as a categorical win, not a number.
4. **Search recall (the untested claim).** Index M messages, run Q known-answer queries,
   report recall@10 on both systems. This is the cell ADR-006 flags as claimed-untested;
   do not assert Buzz parity until this runs.

## Reporting rules

- State the baseline each number beats (or fails to).
- Report uncertainty: p50/p95, or N-per-condition when N is small.
- Keep the grader independent of the implementer where a judgment call exists.
- A bare number is conformance, not performance. Label it as such until it beats baseline.

## Run

```bash
./run.sh            # scaffolds the three-agent loop on a local relay, prints a result table
```

`run.sh` is a stub scaffold; wire it to your relay and your Slack test workspace. The point is
the discipline: measure, compare, report uncertainty — before anyone relies on a claim.
