# Sequence diagrams: common Slack use cases on the Buzz/Nostr substrate

**People are the initial communicators; agents come later.** Day one, this substrate is human
coordination, exactly like Slack: people post, reply, DM, share files, review code. Agents
are added afterward as first-class members that augment the same channels, with their own
portable identity. These diagrams lead with the human flow and show where agents join.

The recurring difference from Slack: on Nostr every actor (person or agent) is a portable
identity, and the record is a signed event on a relay you own, not a workspace in someone's
cloud.

Mermaid renders inline on GitHub.

---

## 0. Adoption sequence: people first, agents later

```mermaid
sequenceDiagram
    participant People
    participant R as Substrate relay
    participant Agents
    People->>R: adopt for human coordination first
    Note over People,R: day one looks like Slack
    Agents->>R: added later as first-class members
    Note over Agents,R: agents augment the same channels,<br/>each with its own portable identity
```

---

## 1. Person posts to a channel

```mermaid
sequenceDiagram
    participant P as Person
    participant R as Relay
    participant DB as Event store
    P->>R: post a message to a channel
    R->>R: verify membership
    R->>DB: persist the event
    R-->>P: delivered to channel members
    Note over R: members are people first,<br/>agents added later
```
*Slack: a person types in a channel; Slack cloud stores and fans out.*

---

## 2. Threaded conversation, an agent assists later

```mermaid
sequenceDiagram
    participant P1 as Person A
    participant R as Relay
    participant P2 as Person B
    participant Ag as Agent, joins later
    P1->>R: ask a question in a channel
    R-->>P2: deliver
    P2->>R: reply in the thread
    R-->>P1: deliver the reply
    Note over Ag: once added, an agent can<br/>watch the thread and assist
    Ag->>R: optional, summarize or act on the thread
```
*Slack: people reply in-thread; a bot can be added to the channel to help.*

---

## 3. Direct message

```mermaid
sequenceDiagram
    participant P1 as Person A
    participant R as Relay
    participant P2 as Person B
    P1->>R: DM addressed to Person B
    R-->>P2: deliver, encrypted
    P2-->>P1: reply
    Note over P1,P2: the same DM path later carries<br/>person-to-agent messages
```
*Slack: a person opens an IM and messages another person.*

---

## 4. Human-in-the-loop approval

```mermaid
sequenceDiagram
    participant Req as Requester, person or agent
    participant R as Relay
    participant W as Workflow step
    participant H as Human approver
    Req->>R: submit an action for approval
    R->>W: enqueue the approval step
    W-->>H: surface approve or deny
    Note over W,H: blocked until a person decides,<br/>a message is data, never authorization
    H->>W: approve
    W->>R: publish the approval
    R-->>Req: unblock, the action proceeds
```
*Slack: Workflow Builder, or an interactive message with Approve and Deny buttons.*

---

## 5. Code review, a pull request

```mermaid
sequenceDiagram
    participant Aut as Author, person
    participant R as Relay
    participant Rev as Reviewer, person
    Aut->>R: open a pull request over NIP-34
    R-->>Rev: deliver the PR
    Rev->>R: review comments
    R-->>Aut: deliver the review
    Aut->>R: revised patch
    Rev->>R: approve
    Note over R: repo, issues, PR, review<br/>are signed events on your relay
```
*Slack: code review lives in GitHub; Slack only relays webhook notifications.*

---

## 6. Share a file

```mermaid
sequenceDiagram
    participant P as Person A
    participant S as Blob store
    participant R as Relay
    participant P2 as Person B
    P->>S: upload a file, content addressed
    S-->>P: blob reference
    P->>R: post a message referencing the blob
    R-->>P2: deliver the message
    P2->>S: fetch the blob
    S-->>P2: the file
```
*Slack: a person uploads a file; it lives in Slack cloud storage.*

---

## 7. Identity portability across relays, no Slack analog

```mermaid
sequenceDiagram
    participant P as Person, one identity
    participant R1 as Relay 1
    participant R2 as Relay 2
    P->>R1: post as themselves
    Note over P: same identity, no re-registration
    P->>R2: post on a different relay
    R2->>R2: verify the identity
    R2-->>P: accepted, attribution preserved
    Note over P: agents added later hold the<br/>same kind of portable identity
```
*Slack: not possible. A person or bot identity is bound to its workspace; Slack Connect
shares channels, not a portable identity the actor holds.*

---

## Reading these against ADR-006

Diagrams 0 to 4 and 6 are the human-first flows: people communicate exactly as they do on
Slack, and you lose nothing there. Diagrams 5 and 7 are where the substrate does something
Slack structurally cannot: in-substrate code review, and a portable identity that people and
agents both hold. Agents (diagram 2) join the same substrate later as first-class members.
That progression, people first then agents, is the case for the migration, and the `eval/`
harness measures it before you rely on it.
