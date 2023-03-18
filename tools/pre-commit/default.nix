{
  system,
  pre-commit-hooks,
  ...
}: let
  excludes =
    ["LICENSE" "CHANGELOG.md"]
    ++ (import ./project-specific.nix {});
in
  pre-commit-hooks.lib."${system}".run {
    src = ./.;
    excludes = excludes;
    hooks = {
      # common
      commitizen.enable = true;
      typos.enable = true;
      yamllint.enable = true;
      markdownlint.enable = true;
      editorconfig-checker.enable = true;
      mdsh.enable = true;
      eslint.enable = true;
      # language
      black.enable = true;
      flake8.enable = true;
      hadolint.enable = true;
      shellcheck.enable = true;
      shfmt.enable = true;
      actionlint.enable = true;
      alejandra.enable = true;

      # rust
      rustfmt.enable = true;
      cargo-check.enable = true;
      clippy-custom = {
        enable = true;
        name = "clippy-custom";
        entry = "cargo-clippy";
        files = "\\.rs$";
        pass_filenames = false;
      };
      cargo-deny = {
        enable = true;
        name = "cargo-deny";
        entry = "cargo deny check";
        files = "\\.rs$";
        pass_filenames = false;
      };
    };

    settings = {
      yamllint.relaxed = true;
      markdownlint.config = {
        # check editorconfig instead
        MD007 = false;
        MD013 = false;
        # for mdsh
        MD031 = false;
      };
    };
  }
