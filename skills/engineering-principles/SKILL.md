---
name: engineering-principles
description: Apply domain-first engineering principles when designing, implementing, refactoring, or reviewing software. Use this as a general decision framework across languages and systems; do not use it to expand the user's scope into speculative refactoring.
metadata:
  origin: original
  maintainer: repository-maintainers
---

# Engineering Principles

Use these principles to guide engineering decisions, implementation, and review.
Apply them with judgment: preserve the user's scope and constraints, explain
material trade-offs, and assess the resulting system rather than mechanically
checking a list.

## Principles

1. **Correctness over convenience — do not fabricate state.** Model the domain
   truthfully. Do not invent values, hide meaningful differences, or permit
   invalid states merely to simplify local code or force an answer.
2. **Parse, don't validate.** Convert weakly structured or untrusted input into
   refined domain values at the boundary, preserve that knowledge, and let the
   core rely on it.
3. **Functional core, imperative shell.** Keep domain decisions deterministic
   and independent from I/O, frameworks, concurrency, and lifecycle. Effects
   belong at the boundary.
4. **Make state, ownership, and transitions explicit.** Prefer values and local
   mutation. Give mutable state and resources clear owners, and represent
   meaningful states directly.
5. **Abstract only over real structure.** Abstract existing invariants, repeated
   semantics, or genuine boundaries. Prefer composition; expose intentional
   semantic divergence instead of hiding it behind adapters.
6. **Operational correctness is correctness.** A change is incomplete if its
   important behavior cannot be observed, diagnosed, safely operated, and
   reviewed in the resulting system.

## Applying the principles

- Establish domain facts and existing invariants before choosing an
  implementation. If information is unavailable, state the uncertainty; do not
  invent plausible values.
- Keep external APIs, serialization, databases, frameworks, and FFI types at
  translation boundaries instead of leaking them into the core model.
- For workarounds, record the reason, known risk, bounded scope or lifetime, and
  removal path.
- Use native mechanisms to express invariants, ownership, errors, absence, and
  alternatives. Do not recreate another language's type system inside the
  current one.
- During review, trace consequences across affected consumers and runtime
  behavior. Improve demonstrated structural defects, but do not use these
  principles to justify unrelated refactoring.

## Further reading

Read [references/foundations.md](references/foundations.md) when the rationale,
examples, or source material behind these principles is relevant.
