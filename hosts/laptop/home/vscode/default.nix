{
  lib,
  pkgs,
  ...
}:

let
  marketplace = pkgs.vscode-marketplace;

  unpublished = {
    "bwees.custom-formatter" = pkgs.callPackage ./pkgs/custom-formatter.nix { };
  };

  resolve = id: unpublished.${id} or (lib.getAttrFromPath (lib.splitString "." id) marketplace);

  baseSettings = import ./settings.nix;
  baseExtensions = import ./extensions.nix;

  mkProfile = profile: {
    userSettings = lib.recursiveUpdate baseSettings (profile.settings or { });
    extensions = map resolve (baseExtensions ++ (profile.extensions or [ ]));
  };
in
{
  programs.vscode = {
    enable = true;

    # Visual Studio Code itself comes from the homebrew cask.
    package = null;
    mutableExtensionsDir = false;

    profiles = lib.mapAttrs (_: mkProfile) {
      default = { };
      Work = import ./profiles/work.nix;
      Infra = import ./profiles/infra.nix;
      Embedded = import ./profiles/embedded.nix;
    };
  };
}
