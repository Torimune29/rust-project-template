{pkgs, ...}: let
  command = {
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
in [
  # sample
  (command {
    name = "print-project-root";
    script = ''
      git rev-parse --show-superproject-working-tree --show-toplevel | head -1
    '';
    description = "Print project root path using git rev-parse";
    example = "print-project-root";
  })
]
