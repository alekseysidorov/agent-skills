---
name: rust-style-guide
description: Write, review, or refactor Rust using the official Rust style, explicit domain invariants, predictable library APIs, and the repository's rustfmt and lint configuration.
---

# Rust style guide

Use this skill for Rust implementation, review, and refactoring. Optimize for
code that is predictable to Rust developers, pleasant to read, and difficult to
use incorrectly.

## Authority and precedence

Apply guidance in this order:

1. The repository's `AGENTS.md`, `Cargo.toml`, `rustfmt.toml`, toolchain file,
   and CI checks.
2. The official Rust Style Guide and the formatter's output.
3. This skill's API and design preferences.
4. Personal taste.

Do not impose a workspace convention on a repository that has an explicit,
working alternative. Do not hand-format code against `rustfmt`; change the
structure when the formatted result is hard to understand.

## Formatting profile

Use the repository's formatter configuration and run `cargo fmt --all` (or its
checked-in equivalent) before review. The local Rust projects commonly use this
shared profile:

```toml
edition = "2024"
unstable_features = true
group_imports = "StdExternalCrate"
imports_granularity = "Crate"
comment_width = 100
wrap_comments = true
```

Treat this as a preference, not a reason to change a project's edition or add
nightly-only formatter options. Imports should be grouped as standard library,
external/workspace crates, then `crate`/`self`/`super`; keep public re-exports
with the external group when that is the repository convention.

The default Rust style is the baseline: four-space indentation, approximately
100-character lines, block indentation, trailing commas in multiline lists, and
no trailing whitespace. Let the formatter decide mechanical details.

## File and declaration structure

Keep a reader's path through a module stable:

1. module documentation and attributes;
2. imports and public re-exports;
3. module declarations;
4. constants and error types;
5. the primary types and their inherent implementations;
6. standard, external, and local trait implementations;
7. tests.

Keep a type and its primary `impl` adjacent. Put the important public API before
private helpers. Within an `impl`, prefer associated constants, other associated
functions, constructors, queries/accessors, then operations.

Use `mod.rs` as a small facade only when the repository uses that module layout;
do not create files or layers just to satisfy a pattern.

## Domain-first APIs

Make invalid states hard to represent at boundaries.

- Parse external strings, bytes, and configuration into domain types once.
- Use enums for closed sets of values and newtypes for invariants that matter.
- Use `From`, `TryFrom`, `AsRef`, `AsMut`, and `Into` when conversions are
  explicit and unsurprising.
- Prefer `&str`/`&[T]` over `&String`/`&Vec<T>` in input positions.
- Use `Cow` when an API genuinely accepts either borrowed or owned data.
- Keep filesystem, subprocess, serialization, and terminal effects at the
  imperative boundary around pure domain logic.

Name APIs according to Rust conventions:

- `new` constructs a value and is usually infallible; use `Default` for a
  meaningful empty value.
- `with_...` is an alternative constructor or builder step.
- `as_...` returns a cheap view, `to_...` performs a conversion, and `into_...`
  consumes `self`.
- Getters are named after the field (`value()`), not `get_value()`; setters use
  `set_value()` when a setter expresses a real operation.
- Extension traits use the `Ext` suffix.

Keep representation private by default. Expose fields only for stable data
models or transparent newtypes. Prefer a constructor, query, transition, or
builder over a getter/setter surface that merely mirrors storage. Do not mix
visibility levels casually; if an invariant needs controlled access, expose a
deliberate method.

## Iterators, generics, and laziness

Prefer the simplest abstraction that communicates the contract.

- `impl Iterator` is fine for private or simple APIs.
- Published library APIs should use a named iterator type when callers need to
  refer to it, generally with an `Iter` suffix.
- Implement `FusedIterator`, `DoubleEndedIterator`, or `ExactSizeIterator` only
  when the semantics are actually guaranteed.
- Prefer lazy adapters when they preserve clarity; avoid collecting only to
  continue iterating.
- Use generics for genuine flexibility and static dispatch, not to hide a simple
  API behind difficult bounds. Use `dyn Trait` where heterogeneity or a stable
  object boundary is the real requirement.

Do not import object-oriented patterns mechanically. Rust's traits, enums,
ownership, iterators, closures, and type states often remove the need for
classic patterns. Apply YAGNI and KISS before introducing a pattern, trait, or
layer.

## Errors, arithmetic, and unsafe code

Return `Result` for expected failure and preserve useful source context. Use
domain errors for invalid state transitions and contextual error types for I/O
or infrastructure failures. Avoid `unwrap()` and `expect()` in production paths;
retain them only when a local invariant is obvious, documented, and cheaper to
express than recovery.

Treat external indices and arithmetic as untrusted until proven otherwise:

- prefer `.get(range)` to panicking slice syntax at input boundaries;
- use checked, saturating, or explicitly validated arithmetic where overflow
  would change behavior;
- keep the validation next to the operation that relies on it.

Prefer safe Rust. When unsafe is necessary, isolate the boundary, state the
invariant in a `SAFETY:` comment, and test the safe-facing contract. The crate's
lint policy decides whether unsafe is forbidden; the skill does not override
that policy.

## Documentation and tests

Public API documentation explains the observable contract: inputs, outputs,
errors, panics, ownership, ordering, feature gates, and representative usage.
Use doctests for the critical path of a public library API so examples remain
compilable. Comments should explain intent, invariants, constraints, or a
non-obvious trade-off; do not narrate syntax.

Name tests with the operation and condition, for example
`parse_rejects_duplicate_ids` or `first_free_id_uses_a_gap`. Keep unit tests
near the implementation and integration tests under `tests/` using only the
public interface. Test domain transitions, boundary behavior, atomicity, and
error paths rather than private implementation shape.

## Review anti-patterns

Flag these unless the repository provides a concrete reason:

- stringly typed closed domains;
- public fields that bypass invariants;
- getter/setter boilerplate that exposes representation;
- `clone()` used to silence ownership errors rather than express ownership;
- `unwrap()`/panicking indexing on external or fallible input;
- broad generic bounds that make an API harder to use than the concrete type;
- boxed iterators in public APIs where a named iterator is practical;
- custom iterator claims not backed by semantics;
- comments that repeat the code or invent an unverified rationale;
- abstractions introduced only to reduce line count or imitate another
  language's design pattern.

## Source material

- [Rust Style Guide](https://doc.rust-lang.org/style-guide/)
- [Rust Design Patterns](https://rust-unofficial.github.io/patterns/)
- [Elegant Library APIs in Rust](https://deterministic.space/elegant-apis-in-rust.html)
- [Rust Development at Sentry](https://develop.sentry.dev/engineering-practices/rust/)
