---
name: code-as-literature
description: Shape code, comments, and documentation for human reading pleasure without sacrificing correctness. Use when writing, editing, reviewing, or refactoring source code and technical documentation, especially when an AI-generated result feels mechanical, noisy, or hard to follow.
---

# Code as Literature

> Code is executed by machines, but read, understood, and changed by people.

Write software as carefully as good technical prose: precise, composed, economical, and pleasant to read. The goal is not merely *decodability*. A reader should be able to follow the author's thought with little friction and, ideally, enjoy the experience.

This is an editorial discipline, not a license to privilege aesthetics over behavior. **Correctness, explicit contracts, and maintainability are non-negotiable.** Never introduce cleverness, indirection, or abstraction solely to make code look elegant.

## When to apply

Use this skill while generating or revising:

- Production code, tests, examples, and configuration.
- Inline comments, API documentation, READMEs, guides, and design documents.
- Agent-generated changes that are technically correct but sound or look mechanical.

Adapt to the project's language, formatter, established conventions, and audience. Follow local style when it is coherent; do not impose a uniform aesthetic across every language or codebase.

## The reader's experience

Optimize three distinct but related qualities:

1. **Visual rhythm.** Line breaks, indentation, spacing, and grouping should reveal the underlying structure. White space is punctuation, not decoration.
2. **Cognitive continuity.** Present concepts in an order that lets the reader build a mental model incrementally. Keep dependencies and reasons close to the code they explain.
3. **Natural technical prose.** Comments and documentation should sound like one engineer explaining something to another: concrete, accurate, calm, and free of rhetorical filler.

Prefer a simple expression of a complex idea over a complex expression of a simple idea.

## 1. Compose code into readable units

### Let visual boundaries follow semantic boundaries

- Keep closely related operations together.
- Separate distinct phases with a blank line when the transition is meaningful.
- Avoid both uninterrupted walls of code and artificial blank lines between every statement.
- Reveal nested structure when that helps the eye parse it; leave short, cohesive expressions compact.
- Preserve visual symmetry for genuinely symmetric operations, but do not force symmetry onto different behaviors.

A blank line should usually mean something changed: preparation becomes execution, execution becomes interpretation, or the happy path gives way to recovery.

### Keep the reader's working set small

- Prefer local names that carry useful meaning and remove the need to mentally evaluate nested expressions.
- Keep relevant state, invariants, and transformations near their use.
- Avoid making the reader jump between unrelated helpers to understand one operation.
- Extract functions when they form a meaningful concept or establish a useful boundary, not merely to reduce line count.
- Repeat a small amount of obvious structure when the alternative introduces an abstraction that is harder to follow.
- Prefer a clear, visible data flow to clever chaining when intermediate steps matter.

### Give concepts honest names

- Name domain concepts rather than implementation trivia.
- Use consistent terms across code, comments, errors, and documentation.
- Do not invent synonyms for the same technical concept to avoid repetition.
- Avoid vague names (`data`, `manager`, `handler`, `process`) when the domain permits greater precision.
- Do not overname a short-lived value whose role is already evident.

### Respect the formatter

Use `rustfmt`, `nixfmt`, and other established formatters. They settle syntactic layout; they do not decide conceptual structure. Change the structure of the expression when necessary rather than fighting the formatter.

## 2. Write comments as preserved engineering knowledge

**A comment should add information the surrounding code does not reliably convey.** The information might be a reason, invariant, constraint, trade-off, surprising behavior, or warning against a tempting but invalid change.

Prefer comments that explain:

- Why a choice was made, particularly when a simpler-looking alternative exists.
- What invariant makes a local optimization or shortcut correct.
- Which external constraint, compatibility requirement, or failure mode matters.
- What would break if someone changed the implementation in an apparently harmless way.
- Where a non-obvious algorithm comes from and which assumptions it needs.

Avoid comments that:

- Narrate syntax or repeat an identifier: `// Iterate over items` before a loop.
- Announce a section without helping navigation.
- Inflate a simple fact with generic phrasing: `Ensure proper handling of...`.
- Speculate about historical reasons or present a plausible guess as established fact.
- Compensate for a confusing design that can reasonably be made clearer in code.

**Important exception:** public API documentation must explain observable behavior and usage even when the implementation makes those obvious. Its audience may never read the implementation.

### A useful contrast

Mechanical:

```rust
// Check whether the context is empty.
if context.is_empty() {
    return;
}
```

Knowledge-preserving:

```rust
// The top frame already contains inherited fields: each child
// receives a flattened copy when its scope is entered.
if let Some(top) = stack.top() {
    // ...
}
```

The second comment explains why reading only the top frame is valid. It protects an invariant rather than describing the `if`.

### Never fabricate rationale

If a workaround looks unusual, inspect tests, blame/history, issues, and external contracts before explaining it. If its reason remains unknown, do not invent a confident `// Required for compatibility` comment. Prefer investigating, leaving the code uncommented, or explicitly identifying the uncertainty in the review discussion.

## 3. Give technical prose a human voice

- State the concrete point early. Avoid ceremonial openings such as “It is important to note that...” or “This section aims to provide...”.
- Prefer active verbs and specific nouns over nominalizations: “Reject unsupported schemes” rather than “Perform validation of scheme support.”
- Vary sentence length according to the idea. Short sentences provide emphasis; longer sentences are justified when they carry an actual explanation.
- Use causal language (`because`, `so`, `otherwise`, `unless`) when it reveals a real dependency.
- Keep technical terminology stable. Repeating `scope` is better than alternating `scope`, `context`, and `environment` for stylistic variety.
- Sound natural, not chatty. Avoid forced jokes, artificial warmth, grand claims, and marketing language.
- Prefer ordinary English contractions when they fit the existing voice; do not enforce them.
- Use examples where they shorten the path to understanding, not merely to fill out a template.
- Avoid monotonous paragraph shapes, repetitive headings, and bullet lists that add no navigational value.

Do not mechanically shorten everything. An accurate, flowing explanation may be longer than a terse but cryptic one.

## 4. Make documentation a guided discovery

Documentation should help the reader construct a useful model in a deliberate order:

1. **Purpose:** What problem does this solve, and what is its boundary?
2. **Concepts:** What are the few entities and relationships needed to understand it?
3. **First use:** What is the smallest realistic working example?
4. **Behavior:** What happens, including errors, ownership, ordering, and lifecycle?
5. **Constraints:** What assumptions, trade-offs, and edge cases matter?
6. **Depth:** Where should an interested reader go next?

This is a useful default sequence, not a mandatory six-heading template. A tiny utility may need two sentences; a complex subsystem may need an entire guide.

For Rustdoc, explain public contracts, errors, panics, safety, feature gates, and representative usage as appropriate. For Nix modules, document the option's meaning, evaluation assumptions, composition, and user-visible consequences. Keep examples executable or clearly marked as illustrative.

A README should not read like a feature advertisement. Show the reader how the system thinks and how to use it correctly.

## 5. Edit for pleasure, not just compliance

After producing correct code, perform a separate **reader's pass**:

1. Read the file top to bottom without mentally filling in omitted context.
2. Notice where your eye stops, where a sentence needs rereading, and where a concept arrives before its explanation.
3. Check whether blank lines mark real transitions and whether adjacent lines belong together.
4. Ask whether every new name, helper, abstraction, and comment earns its cost.
5. Read comments and documentation aloud in your head. Remove formulaic AI prose and redundant explanations.
6. Check that the document alternates orientation, detail, and examples naturally rather than repeating a fixed template.
7. Verify that the editorial changes preserve behavior, tests, public contracts, and formatter output.

The goal is **less friction**, not fewer characters. Do not optimize line counts, comment counts, or readability scores as proxies for enjoyment.

## 6. Review heuristics

Use these questions during review; do not turn them into a mechanical checklist in the generated artifact:

- Can the reader see the program's major phases at a glance?
- Does each paragraph of code express a coherent thought?
- Does the next concept arrive when the reader is ready for it?
- Is any important dependency or invariant hidden far away?
- Is a comment teaching something not apparent from the code?
- Does the prose use concrete, stable language without filler?
- Is the result simpler *to understand*, not merely shorter or more abstract?
- Would an experienced maintainer enjoy reading this six months later?

When reviewing someone else's code, distinguish objective defects from stylistic preferences. Explain the reader cost of a suggested change instead of declaring one layout universally superior.

## 7. Anti-patterns

**Comment wallpaper.** Every operation gets a comment; the reader must read the program twice.

**Artificial breathing room.** Blank lines are inserted at fixed intervals rather than between ideas.

**Premature literary abstraction.** Extra types, traits, helpers, or DSL layers are created to make a design appear elegant.

**Compressed cleverness.** An intricate expression saves lines but increases the reader's mental working set.

**AI ceremonial prose.** Repeated phrases such as “It is worth noting,” “This function is responsible for,” “Ensure proper,” and “seamlessly.”

**False confidence.** Comments confidently explain design motives that were never verified.

**Sterile uniformity.** Every function, paragraph, and comment is forced into the same size and cadence.

**Documentation as duplication.** The same description appears in README, module docs, API docs, and inline comments without serving distinct readers.

## 8. Calibrate to the author and repository

Before changing an established codebase, read representative examples from it, especially files the maintainers consider exemplary. Infer preferences from actual choices, including exceptions; do not infer a rule from one snippet.

Useful style references for this skill's initial calibration:

- [`context-logger`](https://github.com/alekseysidorov/context-logger): scope semantics, comments explaining invariants and recursive-logging hazards, public API docs.
- [`tower-http-client`](https://github.com/alekseysidorov/tower-http-client): small public surface, modular HTTP client API, examples.
- [`nix-devtools`](https://github.com/alekseysidorov/nix-devtools): explicit Nix expression structure, short and expanded forms coexisting.
- [`nixos-common-config`](https://github.com/alekseysidorov/nixos-common-config): declarative composition, semantic grouping, explanatory architecture comments.
- [`log`](https://github.com/rust-lang/log): compact conceptual public API with extensive contracts and documentation.
- [`hyper`](https://github.com/hyperium/hyper): contrasting example of unavoidable protocol/state-machine complexity; useful for studying the limits of formatting alone.

These are **calibration examples, not universally validated gold standards**. Prefer the current repository's conventions to blindly copying another author's style.

## 9. Evidence and further reading

The principles above combine empirical research, established software-writing practice, and editorial judgment. The studies below do **not** prove that one particular formatting style maximizes reading pleasure. They help identify measurable aspects of readability, comprehension, and comment quality; subjective enjoyment still needs direct evaluation with real readers.

1. **Buse & Weimer (2010), _Learning a Metric for Code Readability_.** Empirical model of perceived code readability. Useful for understanding measurable visual features, with the limitation that perceived readability is not the same as comprehension or enjoyment. https://doi.org/10.1109/TSE.2009.70
2. **Miara et al. (1983), _Program Indentation and Comprehensibility_.** Classic study of indentation and comprehension; context-dependent evidence rather than a universal indentation prescription. https://doi.org/10.1145/182.358437
3. **Knuth (1984), _Literate Programming_.** Foundational argument for treating programs as explanations addressed to humans; inspiration, not a requirement to use WEB-style literate programming. https://doi.org/10.1093/comjnl/27.2.97
4. **Hu et al. (2022), _Practitioners’ Expectations on Automated Code Comment Generation_ (ICSE).** Interviews, survey, and literature review showing practitioners care about additional information, concision, usage, and design rationale. https://doi.org/10.1145/3510003.3510152
5. **Katzy et al. (2025), _A Qualitative Investigation into LLM-Generated Multilingual Code Comments and Automatic Evaluation Metrics_ (PROMISE).** Taxonomy of errors in generated comments and limitations of automatic quality metrics. https://doi.org/10.1145/3727582.3728683
6. **Rust API Guidelines.** Practical conventions for predictable public Rust APIs and documentation. https://rust-lang.github.io/api-guidelines/
7. **Diátaxis.** A framework distinguishing tutorials, how-to guides, reference, and explanation by reader need. https://diataxis.fr/
8. **The Documentation System (NixOS).** Nix/NixOS documentation ecosystem and module-option references for domain-specific calibration. https://nixos.org/learn/

### How to improve this skill

Maintain a small corpus of before/after examples with explicit reasons. Prefer paired examples that preserve behavior and differ in structure or prose. Ask experienced readers to compare *ease of understanding*, *reading pleasure*, and *confidence in making a change* separately. Record disagreements and exceptions. Update the principles when repeated evidence contradicts them; do not add new rules merely because they sound elegant.
