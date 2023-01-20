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
      pre-commit = pre-commit-hooks.lib."${system}".run;
      pre-commit-excludes = ["LICENSE" "CHANGELOG.md"];
      pre-commit-pkgs = with pkgs; [
        commitizen
        typos
        yamllint
        nodePackages.markdownlint-cli
        editorconfig-checker
        black
        python310Packages.flake8
        hadolint
        shellcheck
        actionlint
        alejandra

        navi
      ];
    in {
      packages = rec {
        default = pkgs.stdenv.mkDerivation {
          name = "test";
          src = self;
          buildInputs = [pkgs.bash];
          buildPhase = "cp test.sh test.bash";
          installPhase = "mkdir -p $out/bin; install -t $out/bin test.bash";
        };
      };
      apps = {
        default = {
          type = "app";
          program = "${pkgs.bash}/bin/bash";
        };
      };
      checks = {
        build = self.packages.${system}.default;
        pre-commit-check = pre-commit {
          src = ./.;
          # If your hooks are intrusive, avoid running on each commit with a default_states like this:
          # default_stages = ["manual" "push"];
          hooks = {
            # common
            commitizen.enable = true;
            typos.enable = true;
            yamllint.enable = true;
            markdownlint = {
              enable = true;
              excludes = pre-commit-excludes;
            };
            editorconfig-checker = {
              enable = true;
              excludes = pre-commit-excludes;
            };
            # language
            black.enable = true;
            flake8.enable = true;
            hadolint.enable = true;
            shellcheck.enable = true;
            actionlint.enable = true;
            alejandra.enable = true;
          };

          settings = {
            yamllint.relaxed = true;
            markdownlint.config = {
              # check editorconfig instead
              MD007 = false;
              MD013 = false;
            };
          };
        };
      };
      # `nix develop`
      devShells.default = pkgs.mkShellNoCC {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        nativeBuildInputs =
          pre-commit-pkgs
          /*
          ++ [ clang ]
          */
          ;
      };
    });
}
