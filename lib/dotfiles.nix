{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfiles;
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;

  manifest = pkgs.writeText "dotfiles-links" (
    lib.concatStrings (
      lib.mapAttrsToList (target: source: "${home}/${target}\t${cfg.root}/${source}\n") cfg.links
    )
  );

  linkDotfiles = pkgs.writeShellScript "link-dotfiles" ''
    set -euo pipefail

    state="$HOME/.local/state/dotfiles/links"
    mkdir -p "$(dirname "$state")"

    if [ -f "$state" ]; then
      while IFS=$'\t' read -r target source; do
        still_linked=$(awk -F'\t' -v t="$target" '$1 == t' ${manifest})
        if [ -z "$still_linked" ] && [ "$(readlink "$target" || true)" = "$source" ]; then
          echo "removing stale link $target"
          rm "$target"
        fi
      done < "$state"
    fi

    while IFS=$'\t' read -r target source; do
      mkdir -p "$(dirname "$target")"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "backing up $target"
        mv "$target" "$target.backup"
      fi
      ln -sfn "$source" "$target"
    done < ${manifest}

    install -m 644 ${manifest} "$state"
  '';
in
{
  options.dotfiles = {
    root = lib.mkOption {
      type = lib.types.str;
      default = "${home}/environment/dotfiles";
      description = "Live checkout that links point into, so edits apply without a rebuild.";
    };

    links = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Home-relative link path mapped to a path inside `root`.";
    };
  };

  config.system.activationScripts.postActivation.text = ''
    echo "linking dotfiles..."
    su -l ${user} -c ${linkDotfiles}
  '';
}
