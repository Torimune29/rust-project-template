{pkgs, ...}: let
  commandDescriptionDefaultText = "(No description.)";
  commandExampleDefaultText = "(No example.)";
  commandWrapper = {
    name,
    script,
    description ? "",
    example ? "",
  }: {
    name = "${name}";
    package = pkgs.writeShellScriptBin "${name}" ''
      set -euo pipefail
      echo "> Running \"${name}\" ..."
      ${script}
      echo "✔ Done \"${name}\" ..."
    '';
    description = "${description}";
    example = "${example}";
  };
  commands = [
    (commandWrapper {
      name = "check";
      script = ''
        pre-commit run --files $@
      '';
      description = "check files using pre-commit";
      example = "check README.md LICENSE";
    })
    (commandWrapper {
      name = "check-all";
      script = ''
        pre-commit run --all-files
      '';
      description = "check all files using pre-commit";
      example = "check-all";
    })
    (commandWrapper {
      name = "sample";
      script = ''
        echo "This is sample command."
      '';
    })
  ];

  # generate help
  commandUsage = pkgs.lib.concatStrings (
    pkgs.lib.forEach commands (command:
      builtins.toString command.name
      + "\n  description:\n    "
      + (
        if command.description == ""
        then commandDescriptionDefaultText
        else builtins.toString command.description
      )
      + "\n  example:\n    $ "
      + (
        if command.example == ""
        then commandExampleDefaultText
        else builtins.toString command.example
      )
      + "\n")
  );
  helpCommand = commandWrapper {
    name = "help-commands";
    script = ''
      cat <<EOF
      ${commandUsage}
      EOF
    '';
  };
  # for check command examples validation
  commandExamples = pkgs.lib.concatStrings (
    pkgs.lib.forEach commands (command:
      pkgs.lib.optionalString
      (command.example != commandExampleDefaultText)
      (builtins.toString command.example + "\n"))
  );
  testCommandExamples = commandWrapper {
    name = "test-command-examples";
    script = ''
      ${commandExamples}
    '';
  };

  # for passing to devShells
  commandDerivations = pkgs.lib.forEach commands (command: command.package);
in
  commandDerivations ++ [helpCommand.package testCommandExamples.package]
