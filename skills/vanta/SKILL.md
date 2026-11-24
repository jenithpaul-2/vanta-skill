---
name: vanta
description: VANTA is a deterministic, LLM-free code knowledge graph. Use it BEFORE exploring an unfamiliar repository, BEFORE editing a public symbol, and whenever the question is about structure — where something is defined, who calls it, how two symbols connect, what breaks if it changes, or which modules exist. Also use it for a cited evidence pack over a question (`vanta ask`) and for durable code-aware memory. Do not use it for plain text search, config values, or strings a single grep would find.
license: MIT
metadata:
  author: Aethlon
  version: "1.0.0"
---

# VANTA — code intelligence for agents

VANTA builds a deterministic graph of a repository from source: symbols, calls,
imports, docs and their links. It makes no model calls and needs no API key. The
graph is reproducible: two runs over the same tree produce the same answer.

## When to use VANTA

Use it when the answer is **structural**:

| Question | Command |
|---|---|
| Where is X defined, and who calls it? | `vanta query X` |
| Give me everything about X under a token budget. | `vanta context X` |
| How does A reach B? | `vanta path A B` |
| What breaks if I change X? | `vanta blast X --depth 2` |
| What are the load-bearing symbols? | `vanta god-nodes --limit 10` |
| What are the modules here? | `vanta communities` |
| Give me an architecture brief before reading files. | `vanta digest` |
| Answer a question with cited evidence. | `vanta ask "why is extract slow"` |
| Search for a literal or regex. | `vanta search "literal"` or `vanta rg pattern` |

Do **not** use VANTA for:

- plain text search where `rg` is the obvious tool;
- configuration values, secrets, or prose that is not in the graph;
- a symbol you can locate with one `grep` and no callers matter.

## First move in an unfamiliar repository

```bash
vanta doctor                 # is this repo indexed, and is the store healthy?
vanta init                   # only if doctor says the index is missing
vanta digest                 # 10-line architecture brief
vanta god-nodes --limit 10   # the hubs worth understanding first
```

`vanta` with no arguments opens an interactive shell. `vanta --help` lists every
command. Every command accepts `--path <repo>` and `--json`.

## The core loop

1. `vanta digest` to choose targets.
2. `vanta query <symbol>` to see definition, callers and callees.
3. `vanta blast <symbol> --depth 2` before changing a signature.
4. `vanta context <symbol>` when you need one bounded bundle.
5. Read only the files VANTA cites. Do not paste the whole repository.
6. If a result is ambiguous, pin it with `id:<n>` or `file::symbol`; never guess.

## Reading the output

- `[channel]` is the edge kind: `callees`, `dependencies`, `type_users`.
- `<-` entries are **callers**; `->` entries are **callees**.
- Confidence is per edge: `resolved` 1.0, `module` 0.95, same-directory 0.90,
  same-module 0.85, `name` 0.75, `dynamic` 0.35. Treat anything below 0.80 as
  “verify before relying on it”.
- A path is **verified** only when every hop is strong evidence. `--undirected`
  is always unverified; `--heuristic` is labelled.
- `vanta ask` reports its interpretation. `--explain` shows the terms, the
  ranked candidates, and why one won. An ambiguous question still returns
  evidence and exit code 0; `--strict` restores the old exit-code-2 behavior.

## Token discipline for agents

- Prefer `vanta context X` over reading a file. It is budgeted.
- Prefer `vanta digest` over `ls` + several file reads.
- Use `--json` when you will parse; use text when a human will read.
- Ask one narrow question per `vanta ask` call.
- `vanta ask` defaults to 1200 tokens. Lower it with `--budget 600` when the
  answer only needs to pick a file.

## Freshness and the daemon

- The index is incremental. Run `vanta index .` once per session; later runs
  read only changed files.
- `vanta serve` starts a resident daemon. The CLI proxies to it automatically,
  which turns hot queries from a snapshot compile into a buffer read.
- If the graph looks stale after a branch switch, run `vanta index . --force`.
- `vanta doctor` reports index integrity, snapshot age, and daemon state.

## References

- `references/commands.md` — every command and the flags that matter.
- `references/recipes.md` — task-shaped recipes (review, refactor, onboarding).
- `references/output-contract.md` — JSON envelope and evidence rules.
- `references/troubleshooting.md` — ambiguity, stale index, missing symbols,
  Windows/PowerShell behavior.

## Rules of thumb

1. Index once, then query.
2. Read the digest before opening files.
3. Never edit a public symbol without a `blast` result in hand.
4. Pin ambiguity with `id:<n>` / `file::symbol`; do not assume the first hit.
5. Trust verified paths and high-confidence edges; verify the rest.
