{
  description = "bwees nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";
    darwin-login-items.url = "github:uncenter/nix-darwin-login-items";

    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    samber-golang-skills = {
      url = "github:samber/cc-skills-golang";
      flake = false;
    };
    vercel-skills = {
      url = "github:vercel-labs/skills";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      darwin-custom-icons,
      darwin-login-items,
      ...
    }:
    let
      inherit (self) outputs;
      libx = import ./lib { inherit inputs outputs; };
    in
    {
      darwinConfigurations.laptop = libx.createDarwin { hostname = "laptop"; };
    };
}
