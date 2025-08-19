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
    ];

    masApps = {
      "Spark" = 1176895641;
      "Goodnotes" = 1444383602;
      "Xcode" = 497799835;
    };
  };

  # Nix Package Store
  environment.systemPackages = with pkgs; [
    just
    nixfmt-rfc-style
    defaultbrowser
  ];

  imports = [
    ../../resources/icons
  ];
}
