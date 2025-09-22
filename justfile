switch:
  sudo darwin-rebuild switch --flake .#laptop

update:
  nix --extra-experimental-features "nix-command flakes" flake update