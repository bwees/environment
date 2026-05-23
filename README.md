## Initial Install

```
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/environment#laptop
```

## Other installs

Rosetta:

```bash
softwareupdate --install-rosetta
```

Xcode devtools:

```bash
xcode-select --install
```
