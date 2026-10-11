---
name: rust-context-logging
description: Design, implement, or review structured contextual logging in Rust when log records need request, operation, task, or service fields propagated across synchronous scopes and async boundaries.
---

# Rust contextual logging

Use this skill when Rust code needs structured fields to follow work through
call boundaries without turning ordinary logging into tracing instrumentation.
The reference design is the
[`context-logger`](https://github.com/alekseysidorov/context-logger) crate and
the standard [`log`](https://docs.rs/log) ecosystem.

## Choose the right boundary

First decide whether the requirement is logging context or execution tracing.

- Use contextual logging for fields such as `request_id`, `user_id`, `tenant`,
  `operation`, or `component` that should enrich ordinary log records.
- Use `tracing` or another tracing system when the requirement is timeline
  spans, parent-child trace relationships, sampling, or OpenTelemetry export.
- Do not introduce a second instrumentation model merely to attach fields to
  existing `log::info!` and `log::warn!` calls.

## Model context explicitly

Represent context as owned runtime data rather than as a collection of hidden
global variables.

- **Default fields** belong to every record, such as service identity or a build
  version.
- **Inherited fields** flow into child scopes, such as a request or task ID.
- **Local fields** describe only the current operation and may shadow inherited
  fields in the active frame.
- Keep field names stable and domain-specific. Prefer `request_id` over vague
  keys such as `id` or `data`.

When nesting scopes, merge inherited fields from the parent before the child.
Emit inherited fields before local fields so consumers with last-write-wins
semantics allow a local value to shadow an inherited value. Do not rely on field
iteration order in rendered output unless the backend explicitly guarantees it.

## Scope lifetime and async code

Use an RAII guard for short synchronous regions:

```rust
let context = LogContext::new()
    .with_inherited_field("request_id", request_id)
    .with_local_field("operation", "load_profile");

LogScope::in_scope(context, || {
    log::info!("loading profile");
});
```

For async work, attach a context to the future so it is re-entered whenever the
future is polled:

```rust
async {
    log::info!("fetching preferences");
    fetch_preferences().await;
    log::info!("preferences fetched");
}
.in_log_context(context)
.await;
```

Do not hold a thread-local scope guard across `.await`. An executor may poll a
different task on the same thread while the guard is still alive, which can leak
one task's fields into another task's records. When spawning a task, capture the
current context and attach it to the spawned future explicitly.

## Logger integration

Wrap the existing `log::Log` implementation instead of replacing application
logging calls. The wrapper should:

1. preserve the underlying logger's enabled/filtered behavior;
2. evaluate dynamic default fields for the current record;
3. merge defaults, inherited fields, local fields, and record fields in a
   documented order;
4. forward the enriched record to the existing backend.

Structured output requires a backend and feature configuration that actually
consumes `log` key-value fields. A message-only backend cannot display fields
just because the context layer attached them.

## Function-level ergonomics

An attribute macro may create a scope around a function, but it should remain a
logging convenience rather than pretend to create a tracing span. Document:

- whether captures are by value or by reference;
- which capture modifiers are supported (`debug`, `display`, `err`, `serde`);
- whether fields are local or inherited;
- what happens when the function is async;
- whether adding the scope changes ownership or moves an argument.

Prefer explicit code when the generated scope would hide important lifetime,
ownership, or error behavior.

## Review checklist

When reviewing contextual logging, look for these failure modes:

- a guard held across `.await`;
- context stored in process-global mutable state instead of task-safe scope
  propagation;
- missing request/task correlation fields at worker or spawned-task boundaries;
- accidental field collisions with undocumented precedence;
- dynamic field closures doing expensive or fallible work on every record;
- sensitive values copied into inherited context without a redaction policy;
- tests asserting serialized field order rather than field presence and
  precedence;
- comments describing syntax instead of the propagation invariant.

Test the behavior, not the implementation shape: nested inheritance,
local-over-inherited precedence, scope cleanup after panic or early return,
async propagation across `.await`, spawned-task propagation, disabled logging,
and backend-visible structured fields.
