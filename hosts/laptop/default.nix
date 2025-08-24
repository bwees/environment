{ pkgs, ... }:
{
  imports = [
    ./macos.nix
    ./packages.nix

    # projects
    ./projects/immich.nix
  ];
}
