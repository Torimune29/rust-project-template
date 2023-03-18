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
