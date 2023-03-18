{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    command-helper.url = "github:Torimune29/nix-command-helper";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    command-helper,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      pre-commit = import ./tools/pre-commit {inherit system pre-commit-hooks;};
      defaultCommands = import ./tools/commands {
        inherit pkgs;
        project-path = builtins.getEnv "PWD";
      };
      commandHelper = command-helper.packages.${system}.default;
    in {
      packages.default = pkgs.rustPlatform.buildRustPackage rec {
        name = "sample";
        src = ./.;
        cargoLock = {
          lockFile = ./Cargo.lock;
        };
      };
      checks = {
        pre-commit-check = pre-commit;
      };
      # `nix develop`
      # devShells.default = commandHelperRaw {
      devShells.default = commandHelper {
        inherit pkgs;
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        commands =
          defaultCommands
          /*
          ++ customCommands
          */
          ;
        nativeBuildInputs = with pkgs; [
          tree
          commitizen
          # for rust
          rustc
          clippy
          cargo
          rustfmt
          rust-analyzer
        ];
      };
    });
}
