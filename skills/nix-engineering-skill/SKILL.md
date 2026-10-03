---
name: nix-engineering-skill
description: Use Nix as a functional configuration language, not as a bag of convenient wiring tricks.
disable-model-invocation: false
---

# Nix Engineering Skill

Use Nix as a functional configuration language, not as a bag of convenient
wiring tricks. This guidance is useful when designing or reviewing flakes,
overlays, packages, NixOS modules, nix-darwin modules, Home Manager modules, and
repository composition. It was refined through reusable infrastructure work in
projects such as `nix-devtools` and `nixos-common-config`.

The primary goals are:

- explicit dependencies;
- minimal ambient state;
- one clear owner for every capability;
- composable package universes;
- hermetic reusable modules;
- small public APIs;
- no abstractions without a semantic reason.

## Core model

Keep these concepts separate:

```text
flake inputs
    external dependencies owned by the provider

overlay
    transformation of a package universe

pkgs
    one concrete package universe

flake module
    reusable integration mechanism

NixOS / nix-darwin / Home Manager module
    configuration of one system universe

flake.nix
    composition root and repository-specific policy
```

Do not conflate them merely because Nix allows values to be passed between all
of them.

## Dependencies

Prefer lexical dependencies over ambient module arguments.

Good:

```nix
inputs:

{
  lib,
  flake-parts-lib,
  ...
}:

{
  ...
}
```

with:

```nix
flakeModule = importApply ./modules inputs;
```

Avoid introducing provider-specific dependencies through:

```nix
_module.args.foo = ...;
```

unless the dependency genuinely belongs to the module-system environment.
`_module.args` is framework context, not a general service locator.

Prefer dependencies in this order:

```text
lexical closure
    implementation dependency

module option
    explicit configurable dependency

overlay / pkgs
    package-set capability

module args
    framework-provided ambient context
```

Use the lowest level necessary.

## `importApply`

Use `flake-parts-lib.importApply` to construct reusable flake modules with
provider-owned dependencies captured lexically:

```nix
flakeModule = importApply ./modules {
  inherit inputs localPackagesFor;
};
```

Keep the static argument set small. Do not let it evolve into a generic context
object. Composition modules may forward static arguments to child modules, but
consumers should not need to understand provider-owned package plumbing merely
to import a reusable module.

## Package universes

A `pkgs` value is a semantic universe. Do not create parallel ambient package
sets such as `pkgsLocal`, `pkgsCustom`, and `pkgsTools` unless they represent
genuinely different domains.

If a module needs a private package universe, construct it locally:

```nix
let
  pkgs =
    inputs.nixpkgs.legacyPackages.${system}.extend
      inputs.self.overlays.default;
in
{
  ...
}
```

Do not publish that private universe through module arguments. For NixOS,
nix-darwin, and Home Manager modules, use the framework-provided `pkgs` when the
module actually needs it. A module signature documents its dependencies.

## Overlays and local packages

An overlay is the package-set API. Use it to expose reusable builders, package
helpers, concrete packages, and capabilities that naturally belong to `pkgs`.
Consumers that need those capabilities should explicitly apply the overlay.

Keep the repository package namespace separate from the flake `packages` output.
A package namespace may contain derivations, builder functions, helpers, and
package-set capabilities; the flake `packages` output should normally be the
projection containing derivations only.

Do not assume that every value returned by package discovery is a derivation.
Builder functions remain package-set capabilities and normally belong in the
overlay rather than in `packages`.

## Fixed points

Be careful when using values from `final` while constructing an overlay. Avoid
making bootstrap dependencies depend on the fixed point currently being built.

Prefer:

```nix
localPackagesFor =
  { lib, pkgs }:
  lib.filesystem.packagesFromDirectoryRecursive {
    directory = ./pkgs;
    callPackage = lib.callPackageWith pkgs;
  };
```

Then pass bootstrap libraries from outside the fixed point and the final package
set only where it is semantically required.

## Flake modules and repository policy

Reusable flake modules should be hermetic as practical: provider-owned
implementation dependencies are captured lexically, consumer configuration is
expressed through options, and package capabilities are exposed through the
overlay.

Keep repository policy in `flake.nix`. It may pin inputs, assemble public
modules, apply the repository's public overlay, define formatting/checks,
configure development shells, and import repository-only tests. Reusable
mechanisms should not depend on repository-specific tests or development policy.

## Modules, profiles, and facts

Use a separate profile hierarchy only when it carries meaningful policy or role
semantics. Do not create taxonomy merely for directory aesthetics.

Split code by knowledge ownership, not by Nix mechanism:

```text
public reusable code
    what a capability is and how it is configured

private machine configuration
    which concrete capability, endpoint, topology, or policy exists
```

Facts should remain plain data where possible. Consume concrete inventory
directly rather than routing it through module arguments without a real
configuration-language reason.

## Comments and design heuristics

Comments should explain intent, invariants, and ownership boundaries—not repeat
visible syntax.

Prefer:

```text
one semantic package universe
explicit dependency projection
lexical capture
pure helper functions
small module signatures
public APIs consumed internally
values over ambient context
composition over plumbing
```

Avoid:

```text
large specialArgs
large _module.args
context attrsets passed everywhere
parallel pkgs universes without clear meaning
hidden dependency injection
helpers that merely rename syntax
micro-modules with no semantic boundary
premature repository structure
```

When a design requires more plumbing than the underlying capability, check
whether two concepts that should be separate have been coupled accidentally. The
dependency graph should be visible from the code structure itself.
