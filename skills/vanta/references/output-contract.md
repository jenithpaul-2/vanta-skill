# VANTA output contract

Every command with `--json` and every MCP tool returns the same envelope:

```json
{
  "schema": "vanta.result.v1",
  "command": "ask",
  "revision": 5,
  "ok": true,
  "data": { "...": "command-specific report" },
  "ambiguity": [],
  "next": ["vanta context <symbol>"]
}
```

- `schema` is the parser contract. Treat it as a version, not decoration.
- `revision` changes when the graph changes. A different revision between two
  calls means the second answer used a newer graph.
- `ok: false` means `data` carries an error. Exit code is non-zero.
- `ambiguity` is empty when the name resolved to one declaration. Otherwise it
  lists candidates with `id`, `file`, `kind`, `start_line`, `provenance` and a
  `selector`. Pin one with `id:<n>` or `file::symbol`.
- `next` is a deterministic hint. It is cheap to ignore and never required.

## `ask` report

```json
{
  "question": "why is extract slow",
  "revision": 5,
  "budget": 1200,
  "tokens_used": 780,
  "truncated": false,
  "symbol": {"id": 3408, "name": "extract", "kind": "function", "file": "graphify/extract.py", "start_line": 11316, "end_line": 11390},
  "ambiguity": {"query": "why is extract slow", "candidates": []},
  "plan": {"terms": ["extract", "slow"], "chosen": "extract", "strategy": "ranked", "candidates": []},
  "lexical": false,
  "code_spans": [],
  "paths": [],
  "blast": null,
  "memories": [],
  "references": [],
  "semantic": [],
  "citations": [{"kind": "definition", "file": "graphify/extract.py", "line": 11316}],
  "pack": [{"kind": "symbol", "tokens": 20, "text": "..."}]
}
```

Rules the agent can rely on:

- `tokens_used` never exceeds `budget`.
- Every `pack` section has a `kind`; every citation has a real `file` and a
  positive `line` unless it is a community note.
- `lexical: true` means the evidence came from a search fallback, not a symbol.
- `plan.strategy` is `ranked`, `ranked, with alternatives`, `explicit selector`,
  or `no matching declaration`.
- `ok` is true when a symbol or a non-empty pack exists. Ambiguity alone does not
  make the command fail.

## `index --json`

```json
{"files_scanned":722,"files_indexed":1,"files_reused":721,
 "symbols_indexed":10,"edges_indexed":5,"edges_stored":22679,
 "edges_deduplicated":1,"unresolved_references":32,
 "ambiguous_references":6,"elapsed_ms":415,"stats":{...}}
```

`edges_indexed` counts references submitted; `edges_stored` counts relationship
rows after de-duplication. `ambiguous_references` counts names that matched two
or more candidates equally well and were therefore not turned into edges.

## Determinism

Two runs over an unchanged tree produce the same graph and the same answer for
the same query. Anything that changes with a model version belongs in the
semantic plane, not the graph.
