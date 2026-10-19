{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.orcaslicer;
  user = config.system.primaryUser;

  overridesFile = pkgs.writeText "orcaslicer-overrides.json" (builtins.toJSON cfg.overrides);

  patchProfiles = pkgs.writeShellScript "patch-orcaslicer-profiles" ''
    set -euo pipefail

    systemDir="$HOME/Library/Application Support/OrcaSlicer/system"
    if [ ! -d "$systemDir" ]; then
      echo "OrcaSlicer profiles not found, skipping"
      exit 0
    fi

    for type in $(${lib.getExe pkgs.jq} -r 'keys[]' ${overridesFile}); do
      for profile in "$systemDir"/*/"$type"/*.json; do
        [ -f "$profile" ] || continue
        patched=$(${lib.getExe pkgs.jq} --tab --arg type "$type" --slurpfile overrides ${overridesFile} '
          if .type == $type and (has("inherits") | not) then . + $overrides[0][$type] else . end
        ' "$profile")
        if [ "$patched" != "$(cat "$profile")" ]; then
          printf '%s\n' "$patched" > "$profile"
          vendor=$(basename "$(dirname "$(dirname "$profile")")")
          rm -f "$systemDir/$vendor.opc"
        fi
      done
    done
  '';
in
{
  options.orcaslicer.overrides = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
    default = { };
    example = {
      process.brim_type = "no_brim";
    };
    description = "Settings forced into OrcaSlicer's base system profiles, keyed by profile type (process, filament, machine). Profiles that inherit keep their own values.";
  };

  config.system.activationScripts.postActivation.text = lib.mkIf (cfg.overrides != { }) ''
    echo "patching OrcaSlicer profiles..."
    su -l ${user} -c ${patchProfiles} || echo "warning: OrcaSlicer profile patch failed"
  '';
}
