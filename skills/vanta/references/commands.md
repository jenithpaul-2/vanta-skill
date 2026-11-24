# VANTA commands

Every command accepts `--path <repo>` and `--json`. `--json` returns the
`vanta.result.v1` envelope.

## Setup and health

```bash
vanta                      # interactive shell (TTY) or home screen
vanta init                 # register + index + print MCP config
vanta init --agent-rules   # also write VANTA.md and the AGENTS.md pointer
vanta init --hooks         # install post-commit / post-checkout hooks
vanta init --no-index      # register only
vanta index .              # incremental
vanta index . --force      # rebuild from scratch
vanta index . --verbose    # per-file logging
vanta doctor               # paths, integrity, snapshot, daemon
vanta doctor --snapshot    # checksum, revision, age, size
vanta repos                # repositories in the world database
vanta stats --storage      # per-file storage breakdown
vanta vacuum               # reclaim space
vanta watch                # re-index after edits
vanta hooks install        # keep the index warm after commits
vanta update --check       # is a newer release available?
```

## Structure queries

```bash
vanta query <symbol>                 # definition, callers, callees
vanta query <file>::<symbol>         # pin a declaration
vanta query id:<id>                  # pin by stable id
vanta resolve <name>                 # ranked candidates, no silent choice
vanta context <symbol>               # one bounded bundle
vanta path <from> <to>               # directed, evidence-verified
vanta path <from> <to> --undirected
vanta path <from> <to> --heuristic
vanta blast <symbol> --depth 2       # what breaks
vanta blast <symbol> --depth 2 --json
vanta god-nodes --limit 10           # highest total degree
vanta communities                    # Louvain modules
vanta digest                         # architecture brief
```

## Evidence and search

```bash
vanta ask "why is extract slow"              # cited pack, exit 0
vanta ask "why is extract slow" --budget 600
vanta ask "why is extract slow" --explain    # how it was interpreted
vanta ask "why is extract slow" --strict     # exit 2 when ambiguous
vanta ask "id:2463"                          # pin a declaration
vanta search "literal"                       # literal by default
vanta search "pattern" --regex
vanta rg <pattern>                           # ripgrep-compatible
vanta rg -i -w 'window handle' src
vanta rg -g '*.rs' -l unsafe
```

`vanta ask` never invents prose. It packs definition, span, paths, blast radius,
memories, references and semantic pages under the token budget. When nothing
declaration-shaped matches, it falls back to lexical evidence with citations.

## Memory and notes

```bash
vanta memory remember "The store stays the authority." --link symbol:2463
vanta memory recall "index freshness"
vanta memory tree
vanta memory forget <id>
vanta reflect --outcome dead-end --correction "rebuild every file" --symbols 2463
vanta note id:2463 --text "Hot path." --evidence src/lib.rs:2463
vanta note --list
vanta note --sync
vanta pref set test-command "cargo test"
vanta pref list
```

## Semantic plane and wiki

The graph is deterministic. Prose is optional and external.

```bash
vanta semantic plan --kind notes --update
vanta semantic merge .vanta/jobs
vanta semantic status --stale
vanta semantic refresh --apply
vanta wiki build
vanta wiki plan
vanta wiki merge .vanta/jobs
vanta wiki check
vanta wiki export --html
```

## Agent integration

```bash
vanta mcp .                        # MCP server over stdio
vanta install --skills             # vanta + vanta-map skills, offline
vanta batch --file requests.jsonl  # several commands, one process tree
```

MCP config:

```json
{"mcpServers":{"vanta":{"command":"vanta","args":["mcp","."]}}}
```
