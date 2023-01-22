{
  pkgs,
  commands,
  shell ? "mkShellNoCC",
  shellHook ? "",
  nativeBuildInputs ? [],
  ...
}: let
  descriptionDefaultText = "(No description.)";
  exampleDefaultText = "(No example.)";
  # generate help
  usage = pkgs.lib.concatStrings (
    pkgs.lib.forEach commands (command:
      builtins.toString command.name
      + "\n    description:\n        "
      + (
        if command.description == ""
        then descriptionDefaultText
        else builtins.toString command.description
      )
      + "\n    example:\n        $ "
      + (
        if command.example == ""
        then exampleDefaultText
        else builtins.toString command.example
      )
      + "\n")
  );
  help = pkgs.writeShellScriptBin "help-commands" ''
    set -euo pipefail
    cat <<EOF
    ${usage}
    EOF
  '';

  # for check command examples validation
  examples = pkgs.lib.concatStrings (
    pkgs.lib.forEach commands (command:
      pkgs.lib.optionalString
      (command.example != exampleDefaultText)
      (builtins.toString command.example + "\n"))
  );
  testexamples = pkgs.writeShellScriptBin "test-command-examples" ''
    set -euo pipefail
    ${examples}
  '';
  # for passing to devShells
  derivations = pkgs.lib.forEach commands (command: command.package);
in
  pkgs."${shell}" {
    shellHook = shellHook;
    nativeBuildInputs =
      nativeBuildInputs
      ++ derivations
      ++ [help testexamples]
      # ++ [
      #   clang
      # ]
      ;
  }
