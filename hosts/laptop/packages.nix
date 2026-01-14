{
  pkgs,
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
      "affinity"
      "zoom"
      "vlc"
      "utm"
      "docker-desktop"
      "android-studio"
      "gitbutler"
      "zed"
      "sf-symbols"
      "bruno"
      "teamviewer"
      "prusaslicer"
      "bambu-studio"
      "qgroundcontrol"

      # bwees tap
      "firecontrol"

      # obs ndi plugin
      "distroav"
      "libndi"
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
      "mise"
    ];
  };

  # Nix Package Store
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    _1password-cli
    gh
    yt-dlp
    ffmpeg
    wget
    mise
    nmap
    duti
    restic
    rsync
    R

    # zed nix plugin
    nil
    nixd

    # NixOS Rebuild CLI
    nixos-rebuild
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  # see home/bwees.nix for mise packages

  imports = [
    # Icon modifications
    ../../lib/icons
  ];
}
