---
name: lightweight-spec-development
description: Use when planning or implementing a meaningful feature whose intent, implementation boundaries, invariants, or acceptance checks should remain available to future humans and agents. Keep the workflow repository-native and low-ceremony; do not use for tiny fixes, obvious refactors, or formatting-only changes.
metadata:
  origin: original
  maintainer: repository-maintainers
---

# Lightweight Spec Development

Keep feature knowledge close to the repository without introducing a
specification framework, generated registry, schema, database, or custom CLI.
Use ordinary Markdown, Git, and the repository's existing documentation
conventions.

## The document model

- **Work context (optional)** — temporary history of active discussion,
  experiments, bugs, rollout notes, and follow-ups in whatever tracker or
  repository-native place the project actually uses. GitHub Issues are not
  required and are out of scope unless the repository already relies on them.
- **Research document** — evidence, experiments, and comparisons before a
  durable choice is established.
- **Design document** — the current intended or implemented system: behavior,
  boundaries, invariants, and implementation details.
- **Decision document** — the durable rationale for why an architectural choice
  was made.
- **Code** — the executable source of truth.

A design document describes the current system. A decision document explains
why a durable choice was made. Research records evidence before that choice.
Work context records the path taken.

Keep these roles conceptually distinct even when a repository combines some of
them in one document. Do not create a decision document merely because
implementation happened. Use one when a durable architectural choice,
boundary, or trade-off needs to be remembered. If an existing decision covers
it, update or reference that decision instead of creating a duplicate.

## When a design document is warranted

Create or update a design document when the change introduces meaningful
behavior or an invariant, crosses module boundaries, has non-obvious implementation or
operational semantics, needs concrete acceptance checks, or is likely to be
revisited. Do not require one for tiny local fixes, obvious refactors,
formatting, trivial dependency bumps, or self-explanatory code.

Prefer one human-readable Markdown design document per meaningful feature or
architectural change. Reuse the repository's established design-document
location. If none exists, keep the document close to related architectural
documentation. Keep research in the repository's established research
location, and do not turn research into a decision until the evidence supports
one. Do not introduce `docs/features/` merely because this skill mentions
design documents.

## Workflow

Before implementation:

1. Inspect the related code and repository instructions.
2. Read related design documents, research, and decisions; inspect their actual
   naming, headers, dates, statuses, and section conventions.
3. Read linked work context when it exists and is in scope; do not invent an
   issue workflow for a repository that does not use one.
4. Decide whether to create or update a design document, a research document,
   or neither, and whether a durable decision has emerged.
5. Keep the design within the actual requirement. Do not create documentation
   ceremony to make a small change look formal.

During implementation:

- Keep the design or research document aligned with the work actually done.
- Preserve important ownership, module-boundary, lifecycle, migration, and
  operational details in `How`.
- Keep `QA` concrete and observable: describe commands, scenarios, invariants,
  or recovery checks, not only “tests pass”.
- Prefer editing an existing relevant document over creating another one.

After implementation:

- Verify the QA conditions.
- Describe the implemented system, not the abandoned plan.
- Ensure the document does not claim behavior the code does not provide.
- Keep temporary investigation history in the project's existing work context,
  if it has one, rather than copying it into permanent documentation.

## Design-document metadata

For time-bound design, decision, research, and journal documents, prefer the
repository's existing metadata convention. When introducing a convention, use
one compact two-column table immediately below the title. Do not add metadata
to timeless references, runbooks, indexes, or descriptive documentation merely
for visual uniformity:

```markdown
| Field  | Value          |
| ------ | -------------- |
| Status | 🩶 Draft        |
| Date   | 2026-09-30     |
| Type   | Design         |
```

`Date` is the default field for time-bound documents. Use `Status` only when
the document has a meaningful decision or review lifecycle; journal entries
normally need no status because their chronology and evidence are the source
of truth. When status is appropriate, use a colored heart emoji together with
a short text label. The default vocabulary is
`🩶 Draft`, `💛 Review`, `💚 Accepted`, and `💔 Rejected`; preserve an
established repository vocabulary when one exists.
Add only fields that are important for that document, such as `Decision`,
`Scope`, `Revision`, or `Related`; do not add personal authorship or
environment-specific metadata by default. Do not retroactively rewrite
journals, runbooks, or research notes merely to make metadata uniform.

## Design document shape

Use this default only when it fits the repository. Do not add empty sections.

```markdown
# Design or feature name

## Why
The problem and reason this feature exists.

## What
Observable behavior, invariants, and important non-goals.

## How
Implementation details, ownership, boundaries, lifecycle, and constraints.

## QA
Concrete checks that demonstrate the intended behavior.
```

Optional sections such as `Operations`, `Migration`, `Out of scope`, or
`Known limitations` are appropriate only when they carry useful information.

## Principles

- Optimize for low ceremony while preserving knowledge a future human or agent
  actually needs.
- Compress without semantic loss: remove repetition and prose ceremony, but
  preserve distinctions, constraints, rationale, uncertainty, and operational
  detail.
- Prefer denser structure over shorter content.
- Keep implementation details when they are necessary to understand or
  validate the feature; do not shorten documentation into vague architecture
  prose.
- Repository conventions override this default model.
- Do not invent missing facts or pretend an unverified plan is implemented.
