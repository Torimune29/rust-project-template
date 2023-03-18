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
  (command {
    name = "update-rust-project-template";
    script = ''
      set +e
      git fetch template > /dev/null
      RET_FETCH=$?
      set -e
      if [ $RET_FETCH -ne 0 ]; then
        git remote add template http://github.com/Torimune29/rust-project-template
        git fetch template > /dev/null
      fi
      git merge template/main --allow-unrelated-histories
    '';
    description = ''      Update rust-project-template using git.
              It creates branch "template", and you can delete.'';
  })
]
