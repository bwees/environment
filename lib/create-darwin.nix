{ inputs, outputs, ... }:

{
  createDarwin =
    {
      hostname,
      username ? "bwees",
      system ? "aarch64-darwin",
    }:
    let
      customConfPath = ./../hosts/${hostname};
      customConf =
        if builtins.pathExists (customConfPath + "/default.nix") then
          customConfPath + "/default.nix"
        else
          throw "Config not found: ${customConfPath}/default.nix";
    in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit system inputs username; };
      modules = [
        {
          system.primaryUser = username;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = system;
        }
        # Homebrew
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;
          };
        }
        # Home manager
        inputs.home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.${username} = { imports = [ ./../home/${username}.nix ]; };
        }
        # Users
        {
          users.users.bwees = {
            description = "Brandon Wees";
            home = "/Users/bwees";
          };
        }
        inputs.darwin-custom-icons.darwinModules.default
        # install rosetta and xcode devtools
        ../resources/macos-system-tools.nix
        customConf
      ];
    };
}
