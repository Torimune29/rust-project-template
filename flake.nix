{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      pre-commit = import ./tools/pre-commit {inherit system pre-commit-hooks;};
      defaultCommands = import ./tools/commands {inherit pkgs;};
      commandHelper = import ./tools/command-helper {
        inherit pkgs;
        commands =
          defaultCommands
          /*
          ++ customCommands
          */
          ;
      };
      devShellsDefaultPkgs = with pkgs; [
        tree
        commitizen
      ];
    in {
      checks = {
        build = self.packages.${system}.default;
        pre-commit-check = pre-commit;
      };
      # `nix develop`
      devShells.default = pkgs.mkShellNoCC {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        nativeBuildInputs =
          devShellsDefaultPkgs ++ commandHelper
          # ++ [
          #   clang
          # ]
          ;
      };
    });
}
