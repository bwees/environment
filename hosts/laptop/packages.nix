{ config, pkgs, ... }:

{
  # Homebrew Package Manager
  homebrew = {
    enable = true;
    casks = [
      "aldente"
      "visual-studio-code"
      "ungoogled-chromium"
      "discord"
      "signal"
      "notion"
      "ghostty"
      "1password"
      "tailscale-app"
      "obs"
      "spotify"
      "autodesk-fusion"
      "lightburn"

      "affinity-designer"
      "affinity-photo"
    ];

    masApps = {
      "Spark" = 1176895641;
      "Goodnotes" = 1444383602;
      "Xcode" = 497799835;
    };
  };

  # Nix Package Store
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    just
    nixfmt-rfc-style
    defaultbrowser
    ansible
    _1password-cli
  ];

  imports = [
    ../../resources/icons
  ];
}
