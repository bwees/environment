{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./macos.nix
    ./activation.nix
  ];
}
