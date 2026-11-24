# VANTA recipes

## Onboard into an unfamiliar repository

```bash
vanta doctor
vanta digest
vanta god-nodes --limit 10
vanta communities
```

Pick one hub, run `vanta query <hub>`, then open only the files it cites.

## Before editing a public symbol

```bash
vanta query <symbol>
vanta blast <symbol> --depth 2
vanta context <symbol>
```

Read the blast list and the direct callers. If the symbol is ambiguous, pin it:

```bash
vanta blast "id:123" --depth 2
vanta blast "src/api.rs::build_from_json" --depth 2
```

## Trace a request path

```bash
vanta path handler build_from_json
vanta path handler build_from_json --heuristic   # only when the graph lacks evidence
```

A verified path lists every hop with its channel and confidence. If no path is
found, the two symbols may be in disconnected components; reverse the arguments
or query each end.

## Answer "why is this slow?"

```bash
vanta ask "why is extract slow" --budget 900
vanta ask "why is extract slow" --budget 900 --explain
```

If the question names no declaration, VANTA returns lexical evidence instead of
failing. Use `--strict` only when a wrong-but-plausible answer is worse than no
answer.

## Review a change

```bash
vanta blast <changed symbol> --depth 2
vanta context <changed symbol>
vanta ask "what depends on <changed symbol>" --budget 700
```

## Find a literal

```bash
vanta search "MAX_CONNECTIONS"
vanta rg -i 'max_?connections' src
```

Use `vanta search` when the trigram cache is warm; use `vanta rg` for a
ripgrep-compatible scan with globs, types and context.

## Keep the index warm

```bash
vanta init --hooks
vanta hooks status
vanta watch
```

## Agent loop with a strict token budget

```bash
vanta digest --json
vanta context <symbol> --json
vanta ask "<question>" --budget 600 --json
```

Parse the `vanta.result.v1` envelope and stop as soon as you have a file:line to
act on.
