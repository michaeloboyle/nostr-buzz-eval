# ADR-008: Identity lifecycle and account recovery

- **Status:** Proposed
- **Date:** 2026-08-17
- **Tier:** Strategic

## Context

Identity is a keypair the person (or agent) holds (ADR-003), not a provider-managed account.
There is no central password reset. This is the single biggest operational difference from
Slack, and it must have an explicit model rather than being discovered at the worst moment.
Diagrams: [`../user-lifecycle.md`](../user-lifecycle.md).

## Decision

1. **Mandatory secure backup at setup.** When a person creates an identity, the client stores
   the private key in an OS keychain / vault and requires the person to back it up (password
   manager, hardware, or written seed). Onboarding is not complete until the key is backed up.
   The backup is the primary recovery path.

2. **Recovery with a backup is self-service.** Import the backed-up key on a new device; the
   same public key is derived; the identity is fully recovered with history and attribution
   intact. No admin involved. This is the common case, by design.

3. **Loss or compromise without a usable key is key rotation.** Generate a new keypair; the
   community admin re-provisions membership (add the new public key, revoke the old). If the
   old key can still sign, publish a signed migration note so peers can follow the rotation.

4. **Attribution under the old key does not transfer.** Past messages remain signed by the
   old key. This is a known, bounded gap versus Slack's account-level recovery, and it is
   stated openly, not hidden.

## Consequences

**Positive**
- Recovery is predictable and mostly self-service (flow 3), so long as backup discipline holds.
- The community admin is a clear trust anchor for the hard case (flow 4), which fits the
  one-community-per-venture model (ADR-007).
- No provider can lock out, reset, or impersonate an identity.

**Negative / operational**
- Recovery burden shifts to the person's backup discipline. A lost key with no backup means a
  new identity, not the old one restored.
- Admins carry a re-provisioning responsibility and must verify out-of-band that a
  re-provisioning request is genuine (social-engineering surface).

## Notes

Enforce the backup step in the setup flow; do not treat it as advisory. The whole model rests
on flow-3 (restore-from-backup) being the common path and flow-4 (rotation) being rare.
Agents follow the same lifecycle: their keys live in a secret store and are backed up and
rotated by the same discipline.
