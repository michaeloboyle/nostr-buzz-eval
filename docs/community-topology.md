# Community topology: a venture community with activity

The sequence diagrams show flows over time. This is the companion view: the **shape** of a
single venture community and where activity concentrates. One community per venture (ADR-007);
people are the primary members, agents join as first-class members later.

Mermaid renders inline on GitHub. Validated with mermaid-cli.

---

## A venture community, structure plus activity

```mermaid
flowchart TB
    classDef person fill:#dbeafe,stroke:#1e40af,color:#1e3a8a;
    classDef agent fill:#dcfce7,stroke:#166534,color:#14532d;
    classDef channel fill:#f1f5f9,stroke:#475569,color:#0f172a;
    classDef store fill:#fef9c3,stroke:#a16207,color:#713f12;

    subgraph comm["Venture community, one per venture"]
        gen["#general"]:::channel
        dec["#decisions"]:::channel
        disp["#dispatch"]:::channel
        alert["#alerts"]:::channel
    end

    subgraph relay["Self-hosted relay"]
        DB[("Event store")]:::store
        BLOB[("Blob store")]:::store
    end

    P1(["Person A"]):::person
    P2(["Person B"]):::person
    MA["ma agent"]:::agent
    AG1["venture agent 1"]:::agent
    AG2["venture agent 2"]:::agent

    P1 -->|"posts, replies"| gen
    P2 -->|"posts, replies"| gen
    P1 -->|"proposes"| dec
    P2 -->|"approves"| dec
    MA -->|"routes tasks"| disp
    AG1 -->|"status, returns"| disp
    AG2 -->|"PR review, NIP-34"| gen
    AG1 -->|"raises"| alert

    comm ==>|"signed events"| relay
    gen -.->|"media refs"| BLOB
    gen -.->|"persist"| DB
    disp -.->|"persist"| DB
```

**Legend.** Blue = people (the initial communicators). Green = agents (join later). Grey =
channels inside the one community. Yellow = relay-side stores. Solid edges are member activity;
the heavy edge is the community writing signed events to the relay; dotted edges are
persistence and media.

---

## What the shape tells you

- **The community is the boundary.** Everything above lives in one venture's community; a
  second venture is a second community with its own members and relay placement (ADR-007).
- **People and agents are peers on the same graph.** An agent is another member node with its
  own identity (ADR-003), not a bot bolted onto a human workspace.
- **Activity concentrates by channel, not by actor type.** `#general` carries human
  conversation and agent code review; `#dispatch` carries agent coordination; `#decisions`
  carries human approvals. The same relay records all of it as signed events you own.
- **The relay is the single owned record.** Every edge into the community resolves to a signed
  event in your event store, with media in your blob store. No vendor sits in the path.
