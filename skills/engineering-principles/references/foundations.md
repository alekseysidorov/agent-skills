# Engineering Principles: Foundations

## 1. Correctness over convenience — do not fabricate state

The representation should match the domain. Do not invent values or force a
convenient answer when the required fact is absent. Absence, alternatives,
incompatibilities, and divergent models must remain visible. Where practical,
encode invariants so invalid states cannot be constructed.

Prefer:

```text
Pending | Active | Failed
```

over combinations such as:

```text
isStarted + isReady + hasFailed
```

that permit meaningless states. Trust contracts once established; speculative
fallbacks can hide contract violations.

## 2. Parse, don't validate

A check that proves something and then discards that knowledge forces every
caller to prove it again.

```text
untrusted input → parse → refined domain value → domain logic
```

External APIs, serialization formats, databases, frameworks, and FFI types
should normally be translated at the boundary.

Source: Alexis King,
[Parse, don't validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/).

## 3. Functional core, imperative shell

Separate decisions from effects. The core should not know how values were
fetched, persisted, scheduled, transported, or presented. Networking, storage,
async execution, clocks, framework lifecycle, and similar effects belong in the
shell.

Sources:
[Functional Core, Imperative Shell](https://functional-architecture.org/functional_core_imperative_shell/)
and
[Google Testing Blog](https://testing.googleblog.com/2025/10/simplify-your-code-functional-core-imperative-shell.html).

## 4. State, ownership, and transitions

Prefer immutable values and transformations by default. When mutation is
necessary, keep it local and give it an obvious owner. Use the language's native
mechanisms for ownership, errors, absence, alternatives, and exhaustive state
handling.

## 5. Abstraction and composition

Do not generalize from an imagined future. Good abstractions capture repeated
invariants, real boundaries, repeated behavior with the same semantics, or
genuine algebraic structure. If implementations diverge semantically, expose
that difference.

Prefer composition to inheritance. Plain functions and data are often better
than inventing objects merely to give behavior a home.

Sources: _Design Patterns_ by Gamma, Helm, Johnson, and Vlissides; Steve Yegge,
[Execution in the Kingdom of Nouns](https://steve-yegge.blogspot.com/2006/03/execution-in-the-kingdom-of-nouns.html).

## 6. Operational correctness

A feature is not complete merely because its happy path works. Important
behavior should be observable enough to answer:

```text
What happened? Where? Why? What state is the system in now?
```

Logs, metrics, traces, counters, health signals, and diagnostics are part of
correctness when production behavior depends on them. Review the resulting
system, not merely whether the ticket appears complete.

Further reading: Yaron Minsky's discussion of making illegal states
unrepresentable, elaborated by Scott Wlaschin in
[Designing with types](https://fsharpforfunandprofit.com/posts/designing-with-types-making-illegal-states-unrepresentable/).
