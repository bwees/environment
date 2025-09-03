{ pkgs, ... }:
{
  imports = [
    ./macos.nix
    ./packages.nix
  ];
}
