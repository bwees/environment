{
  description = "bwees nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
    darwin-login-items.url = "github:uncenter/nix-darwin-login-items";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      darwin-custom-icons,
      darwin-login-items,
      home-manager,
    }:
    let
      inherit (self) outputs;
      libx = import ./lib { inherit inputs outputs; };
    in
    {
      darwinConfigurations.laptop = libx.createDarwin { hostname = "laptop"; };
    };
}
