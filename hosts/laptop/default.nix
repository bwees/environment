{ ... }:
{
  imports = [
    ./macos.nix
    ./packages.nix
    ./dotfiles.nix
    ./vscode.nix
    ./kube.nix
  ];
}
