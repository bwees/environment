{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.system.primaryUser;
  vscodeDotfiles = ../../dotfiles/vscode;
  userDir = "Library/Application Support/Code/User";
  codeCli = "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code";

  readExtensions =
    file:
    lib.optionals (builtins.pathExists file) (
      lib.filter (line: line != "" && !lib.hasPrefix "#" line) (
        map lib.trim (lib.splitString "\n" (builtins.readFile file))
      )
    );

  baseExtensions = readExtensions (vscodeDotfiles + "/extensions.txt");

  profiles = lib.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir (vscodeDotfiles + "/profiles"))
  );

  profileExtensions =
    name: baseExtensions ++ readExtensions (vscodeDotfiles + "/profiles/${name}/extensions.txt");

  # usage: vscode-install-extensions [--profile <name>] <id or .vsix url>...
  installExtensions = pkgs.writeShellScript "vscode-install-extensions" ''
    set -euo pipefail

    profileArgs=()
    if [ "''${1:-}" = "--profile" ]; then
      profileArgs=("$1" "$2")
      shift 2
    fi

    # Reinstalling a vsix into a named profile fails while VS Code is running.
    installed=$(${lib.escapeShellArg codeCli} "''${profileArgs[@]}" --list-extensions 2>/dev/null)
    isInstalled() { grep -qixF "$1" <<< "$installed"; }

    downloads=$(mktemp -d)
    trap 'rm -rf "$downloads"' EXIT

    args=()
    for ext in "$@"; do
      case "$ext" in
        https://*)
          vsix="$downloads/$(basename "$ext")"
          ${lib.getExe pkgs.curl} -fsSL -o "$vsix" "$ext"
          id=$(${lib.getExe pkgs.unzip} -p "$vsix" extension/package.json | ${lib.getExe pkgs.jq} -r '"\(.publisher).\(.name)"')
          isInstalled "$id" || args+=(--install-extension "$vsix")
          ;;
        *)
          isInstalled "$ext" || args+=(--install-extension "$ext")
          ;;
      esac
    done

    if [ ''${#args[@]} -eq 0 ]; then
      exit 0
    fi

    if ! output=$(${lib.escapeShellArg codeCli} "''${profileArgs[@]}" "''${args[@]}" 2>&1); then
      echo "$output" >&2
      exit 1
    fi
  '';

  # `code --profile` refuses profiles missing from storage.json, so register them first.
  syncVscode = pkgs.writeShellScript "sync-vscode" ''
    set -euo pipefail

    if [ ! -x ${lib.escapeShellArg codeCli} ]; then
      echo "VS Code not installed, skipping extensions"
      exit 0
    fi

    storage="$HOME/${userDir}/globalStorage/storage.json"
    mkdir -p "$(dirname "$storage")"
    [ -f "$storage" ] || echo '{}' > "$storage"
    ${lib.getExe pkgs.jq} --argjson names ${lib.escapeShellArg (builtins.toJSON profiles)} '
      .userDataProfiles = reduce $names[] as $name (.userDataProfiles // [];
        if any(.[]; .name == $name) then . else . + [{ location: $name, name: $name }] end)
    ' "$storage" > "$storage.tmp"
    mv "$storage.tmp" "$storage"

    ${installExtensions} ${lib.escapeShellArgs baseExtensions}
    ${lib.concatMapStringsSep "\n" (
      name: "${installExtensions} --profile ${lib.escapeShellArgs ([ name ] ++ profileExtensions name)}"
    ) profiles}
  '';
in
{
  dotfiles.links = {
    "${userDir}/settings.json" = "vscode/settings.json";
  }
  // lib.listToAttrs (
    map (
      name:
      lib.nameValuePair "${userDir}/profiles/${name}/settings.json" "vscode/profiles/${name}/settings.json"
    ) profiles
  );

  system.activationScripts.postActivation.text = ''
    echo "installing VS Code extensions..."
    su -l ${user} -c ${syncVscode} || echo "warning: VS Code extension install failed"
  '';
}
