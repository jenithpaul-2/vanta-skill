# VANTA troubleshooting

## `vanta` prints a home screen instead of a shell

The interactive shell only starts when stdin and stdout are terminals. In CI,
piped commands, or a captured session, VANTA prints the static home screen so it
can never block. That is intentional.

## `vanta init` seems to do nothing

Fixed in 0.3.4: the header and a progress line appear immediately. Phases are
`scanning files`, `hashing changed files`, `parsing changed files`, `building
symbol table`, `resolving references`, `storing graph`, `building trigram cache`,
`compiling snapshot`.

If the process is still running with no output, `VANTA_NO_ANIMATION=1` switches
to plain phase lines. `CTRL-C` restores the cursor.

## `vanta ask` returned candidates instead of one answer

That is the supported behavior. The pack uses the best-scoring declaration and
lists the alternatives. Pin one:

```bash
vanta ask "id:3408"
vanta ask "graphify/extract.py::extract"
vanta ask "why is extract slow" --explain
```

Use `--strict` only when an ambiguous result must fail the command.

## The answer looks stale

```bash
vanta doctor
vanta index .
vanta index . --force
```

`doctor` shows the snapshot revision and age. A branch switch that renames many
files is a good reason for `--force`.

## `No path found`

The two symbols are in disconnected components. Reverse the arguments, or query
each end with `vanta query`. `--undirected` may connect them, but the path is
then unverified; `--heuristic` admits weak hops and labels the report.

## A symbol is missing

- Confirm the extension is in VANTA's language list.
- Re-index; a file added after the last index is not in the graph.
- `vanta resolve <name>` shows near matches and their provenance.
- A fixture with the same name can outrank the real declaration; pin with
  `file::symbol`.

## PowerShell shows a red `NativeCommandError`

Fixed in 0.3.4: the daemon hint moved to stdout and is suppressed for `--json`,
pipelines and `VANTA_NO_HINTS=1`. Real errors still go to stderr with a non-zero
exit code.

## The daemon is not running

```bash
vanta serve
vanta doctor
```

Without the daemon the CLI compiles a snapshot in-process. Answers are the same;
hot queries are slower. The hint is informational, not a warning.

## Windows console shows raw escape codes

0.3.4 enables virtual-terminal processing and UTF-8 output on Windows. If a host
still cannot render color, set `NO_COLOR=1` or `VANTA_NO_COLOR=1`. For a
non-Unicode code page, set `VANTA_ASCII=1` where supported.
