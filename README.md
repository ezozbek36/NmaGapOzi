# [WIP] NmaGapOZi

> **A modular, desktop-first chat client shell.
> Built like LEGO. Config-first. Provider-agnostic.**

⚠️ **Work in Progress**
This project is in an early experimental stage.
APIs will change. Things may break. Expect rough edges.

🤖 **AI-assisted development**
This project is actively developed with the help of AI coding agents (e.g. OpenCode and similar tools).
Architecture, boilerplate, and iterations may be partially AI-generated and then reviewed/refined by a human.

---

## What is this?

NmaGapOZi is a **desktop chat client platform**, not “just another messenger”.

It is designed as a **customizable shell** where:

* the UI layout is **config-driven**,
* the core logic is **provider-agnostic**,
* and future extensions are built as **isolated components**, not forks.

Think **IDE-like workflows**, not a locked-down chat app.

This is also an experiment in **human + AI collaborative software development**,
exploring how far complex system architecture can be pushed with AI-assisted workflows.

---

## What this project is *not*

* ❌ Not a Telegram fork
* ❌ Not a mobile-first app
* ❌ Not a feature-stuffed “mod client”
* ❌ Not focused on end-users (yet)

This project targets **power users, developers, and system-oriented users** who care about control, structure, and composability.

---

## Core ideas

### 1. Config-first UI

The interface is described declaratively:

* layout (panels, splits, visibility)
* themes and UI tokens
* keybindings
* commands

The UI is **assembled from configuration**, not hardcoded.

---

### 2. Provider-agnostic core

The chat logic is abstracted behind a provider interface.

Today:

* a **deterministic mock provider** (for development and testing)

Later (out of scope for now):

* Telegram
* Matrix
* other protocols

The UI does not know *which* provider is used.

---

### 3. Desktop-first by design

This project assumes:

* keyboard-driven interaction
* command palettes
* resizable panels
* multi-pane layouts

Mobile support is **not a goal**.

---

### 4. Clear separation of concerns
- **Rust** → primary application runtime, core logic, state machines, providers, lifecycle
- **Flutter** → embedded UI layer (rendering, widgets, interaction)
- **Embedder layer** → Rust-hosted Flutter engine, event-driven boundary

Rust is the source of truth.  
Flutter is treated as an embedded UI surface.

---

## Why does this exist?

Because existing chat clients usually force you to choose between:

* convenience **or**
* control

This project explores a third option:

> **Chat as a configurable workspace**, not a fixed product.

This project is also an experiment in building a **Rust-first reference architecture** using **AI-assisted engineering** as part of the development process.

---

## Who is this for?

* developers
* power users
* Linux / Nix / Arch-style users
* people who enjoy configuring their tools
* contributors interested in UI architecture, state machines, and protocol abstraction

If you’re looking for a polished daily driver — this is not it (yet).

---

## Tech stack

- **Primary language:** Rust
- **UI:** Flutter (embedded via Rust Flutter embedder)
- **Architecture:** Rust-driven, event-based, config-first
- **Repo:** monorepo (multiple packages, not a single app)

Exact implementation details (especially embedder boundaries) may evolve.

---

## Nix (reproducible dev/build)

This monorepo now uses a flake-first Nix setup for Linux (`x86_64-linux`).

Quick start:

```bash
nix develop
melos bootstrap
```

Build and checks:

```bash
nix flake check
nix build .#nma-gapp-rs
nix build .#nma-gapp-flutter-linux
```

Run app entrypoints:

```bash
nix run .#nma-gapp-rs
nix run .#nma-gapp-flutter
```

Detailed flake documentation, migration notes, and troubleshooting are in `docs/nix-flake.md`.

---

## Current status (Phase 0)

Implemented / in progress:

* Monorepo setup
* Config system (versioned, mergeable, hot-reload)
* Abstract provider API
* Deterministic mock provider
* Desktop UI shell
* Authentication flow (mock)
* Chat list
* Message list (with pagination)
* Send message (optimistic + ack/fail simulation)
* Debug / inspector tooling

What is **not** implemented yet:

* real chat providers
* plugin system
* sandboxing
* persistence beyond mock data
* production-grade security

---

## Contributing

This project is **open-source and experimental**.

Contributions are welcome, especially in:

* architecture discussions
* core abstractions
* config and layout design
* mock provider realism
* documentation

Contributors should be aware that:
- parts of the codebase may be AI-generated,
- clarity, reviewability, and correctness matter more than authorship,
- refactoring AI-generated code is expected and encouraged.

Before opening large PRs, please open an issue or discussion.

---

## Roadmap

* Phase 0: shell + mock provider ✔️ / 🚧
* Phase 1: stabilize core APIs
* Phase 2: extension points (still without third-party plugins)
* Phase 3: first real provider adapter
* Phase X: plugin sandboxing & ecosystem (maybe)

No deadlines. No promises.

AI tooling will likely continue to be used throughout all phases.

---

## License

This project is licensed under the GNU Affero General Public License v3 (AGPLv3). See [LICENSE](./LICENSE) for details.
