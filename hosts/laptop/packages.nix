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
    onActivation.cleanup = "zap";

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
      "orcaslicer@nightly"
      "affinity-designer"
      "affinity-photo"
      "zoom"
      "vlc"
      "utm"
      "docker-desktop"
      "android-studio"
      "gitbutler"

      # bwees tap
      "firecontrol"
    ];

    masApps = {
      "Spark" = 1176895641;
      "Goodnotes" = 1444383602;
      "Xcode" = 497799835;
    };

    taps = [
      "bwees/tap"
    ];

    brews = [
      "mas"
      "cocoapods"
    ];
  };

  # Nix Package Store
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    defaultbrowser
    _1password-cli
    gh
    yt-dlp
    ffmpeg
    wget
    mise
    nmap
    duti
    postgresql
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  # see home/bwees.nix for mise packages

  imports = [
    # Icon modifications
    ../../resources/icons
  ];
}
