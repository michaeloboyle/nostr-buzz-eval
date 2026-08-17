# User lifecycle: setup, onboarding, account recovery

People are the initial communicators (see `sequence-diagrams.md`), so their lifecycle on the
substrate matters as much as messaging. Three flows: first-time **setup** (create an
identity), **onboarding** (join a venture community), and **account recovery** (the honest
hard edge, because identity is a key you hold, not a password someone can reset).

Decision record for the recovery model: [`adrs/008-identity-lifecycle-and-recovery.md`](adrs/008-identity-lifecycle-and-recovery.md).

Mermaid renders inline on GitHub. All diagrams validated with mermaid-cli.

---

## 1. Setup, first-time identity

```mermaid
sequenceDiagram
    participant P as Person
    participant C as Client app
    participant K as Keychain or vault
    P->>C: create identity
    C->>C: generate a Nostr keypair
    C->>K: store the private key, nsec
    C-->>P: show the public key, npub
    Note over P,K: back up the private key now,<br/>it is the only way to recover this identity
    P->>C: set display name and profile
```
*Slack: sign up with email plus a password the provider can reset. Here you hold the key, so
the backup step at setup is not optional.*

---

## 2. Onboarding, join a venture community

```mermaid
sequenceDiagram
    participant Ad as Community admin
    participant R as Relay
    participant P as New member
    Ad->>R: add member by public key, npub
    R-->>P: membership granted
    P->>R: join channels
    P->>R: first message
    R-->>P: delivered
    Note over Ad,R: one community per venture,<br/>membership is by public key
```
*Slack: an admin invites an email into the workspace. Here membership is granted to a public
key, and one community equals one venture (ADR-007).*

---

## 3. Account recovery, you have a backup

```mermaid
sequenceDiagram
    participant P as Person
    participant B as Key backup
    participant C as New device client
    participant R as Relay
    P->>B: retrieve the private key, nsec
    P->>C: import the private key
    C->>C: derive the same public key
    C->>R: reconnect as the same identity
    R-->>P: full access, no admin needed
    Note over P,R: same key, attribution and history intact
```
*Slack: reset a password. Here, restoring the backed-up key fully recovers the identity with
no admin involved.*

---

## 4. Account recovery, key lost or compromised

```mermaid
sequenceDiagram
    participant P as Person
    participant C as Client app
    participant Ad as Community admin
    participant R as Relay
    P->>C: generate a new keypair
    C-->>P: new public key, npub
    P->>Ad: request re-provisioning, out of band
    Ad->>R: add the new public key as a member
    Ad->>R: revoke the old public key
    R-->>P: access restored under the new identity
    Note over P,Ad: if the old key can still sign, publish a<br/>signed migration note so peers follow it
    Note over P,R: history under the old key stays put,<br/>attribution does not transfer, this is the Slack-parity gap
```
*Slack: the provider resets the account and history follows. Here, a lost key cannot be
regenerated: the community admin is the trust anchor that re-provisions membership to a new
key. This is the honest cost of holding your own identity (ADR-003, ADR-008).*

---

## The tradeoff, stated plainly

| | Slack | Substrate |
|--|--|--|
| Who holds identity | provider | the person (a keypair) |
| Recovery with backup | password reset | import the key, history intact |
| Recovery without backup | provider resets account | admin re-provisions a new key; old-key attribution does not transfer |
| Trust anchor | the provider | the person's backup, then the community admin |

The upside (own your identity, portable across relays) and the downside (recovery is your
backup discipline plus admin re-provisioning) are the same coin. ADR-008 makes the backup
step mandatory at setup precisely to keep flow 3 the common case and flow 4 the rare one.
