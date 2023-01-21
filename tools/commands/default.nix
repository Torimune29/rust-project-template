{pkgs, ...}: let
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
      echo "✔ Done \"${name}\" !"
    '';
    description = "${description}";
    example = "${example}";
  };

  pythonWrapper = {
    commandWrapper,
    libraries ? [],
  }: {
    name = "${commandWrapper.name}";
    package = pkgs.writers.writePython3Bin "${commandWrapper.name}" {
      libraries = libraries;
    } "${commandWrapper.script}";
    description = "${commandWrapper.description}";
    example = "${commandWrapper.example}";
  };
in [
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
  (pythonWrapper {
    commandWrapper = {
      name = "pythontest";
      script = builtins.readFile ./python/pythontest.py;
      description = "python test";
      example = "pythontest";
    };
    libraries = with pkgs.python3Packages; [pyyaml];
  })
]
