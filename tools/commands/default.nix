{pkgs, ...}: let
  commandWrapper = {
    name,
    script,
    description ? "(No description.)",
    example ? "(No example.)",
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
      + "\n  description: "
      + builtins.toString command.description
      + "\n  example:\n    $ "
      + builtins.toString command.example
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

  # for passing to devShells
  commandDerivations = pkgs.lib.forEach commands (command: command.package);
in
  commandDerivations ++ [helpCommand.package]
