{
  config,
  pkgs,
  inputs,
  ...
}:

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

      # bwees tap
      "firecontrol"
      "orcaslicer-bwees@nightly"
    ];

    masApps = {
      "Spark" = 1176895641;
      "Goodnotes" = 1444383602;
      "Xcode" = 497799835;
    };

    taps = [
      "bwees/tap"
    ];
  };

  # Nix Package Store
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    just
    nixfmt-rfc-style
    defaultbrowser
    ansible
    _1password-cli
    gh
  ];

  imports = [
    # Icon modifications
    ../../resources/icons
  ];
}
