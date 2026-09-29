{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-devtools = {
      url = "github:alekseysidorov/nix-devtools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.nix-devtools.flakeModule
      ];

      perSystem = { system, ... }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system}.extend
            inputs.nix-devtools.overlays.default;
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.deno.enable = true;
          };

          gitHooks.pre-commit = pkgs.writeNushellScript "pre-commit" ''
            print "⚡️ Formatting Markdown files..."
            nix fmt -- --fail-on-change
          '';
        };
    };
}
