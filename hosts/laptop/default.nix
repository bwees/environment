{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./macos.nix
    ./developer.nix
    ./activation.nix
  ];
}
