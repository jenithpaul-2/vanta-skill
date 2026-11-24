# VANTA agent skill

A portable Agent Skill for [VANTA](https://vanta.aethlon.xyz), the deterministic,
LLM-free code knowledge graph. It teaches a coding agent **when** to use VANTA
and **how** to read the evidence without guessing.

## Install

```bash
npx skills add aethlon/vanta-skill
```

Pick the `vanta` skill and your host agent. To install globally:

```bash
npx skills add aethlon/vanta-skill --global --skill vanta
```

The skill uses the `vanta` binary. If it is not installed, follow
https://vanta.aethlon.xyz/docs, then verify with:

```bash
vanta --version
vanta doctor
```

## What the agent learns

- Use `vanta digest` before opening files in an unfamiliar repository.
- Use `vanta query` / `vanta context` for definitions, callers and callees.
- Use `vanta blast` before changing a public symbol.
- Use `vanta path` for a directed, evidence-verified route.
- Use `vanta ask` for a cited evidence pack, and `--explain` to see why a
  declaration won.
- Do **not** use VANTA for plain text search where `rg` is the right tool.
- Pin ambiguity with `id:<n>` or `file::symbol` instead of guessing.

## Layout

```text
skills/vanta/
├─ SKILL.md
├─ references/
│  ├─ commands.md
│  ├─ recipes.md
│  ├─ output-contract.md
│  └─ troubleshooting.md
└─ scripts/
   ├─ preflight.sh
   └─ preflight.ps1
```

`SKILL.md` is the trigger and decision tree. References are loaded only when
needed, which keeps the always-on context small.

## Offline copy

The same files are embedded in the VANTA binary. Run this inside a repository:

```bash
vanta install --skills
```

It writes `vanta` and `vanta-map` to `.claude/skills/` and `.agents/skills/`.

## License

MIT. See [LICENSE](LICENSE).
