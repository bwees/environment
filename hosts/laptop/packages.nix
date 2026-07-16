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
      "helium-browser"
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
      "orcaslicer"
      "affinity"
      "zoom"
      "vlc"
      "utm"
      "docker-desktop"
      "android-studio"
      "zed"
      "sf-symbols"
      "bruno"
      "teamviewer"
      "prusaslicer"
      "bambu-studio"
      "qgroundcontrol"
      "zulip"
      "balenaetcher"
      "raspberry-pi-imager"
      "kicad"

      "firecontrol"
      "boring-notch"

      # obs ndi plugin
      "distroav"
      "libndi"
      "ndi-tools"
    ];

    masApps = {
      "Spark" = 1176895641;
      "Goodnotes" = 1444383602;
      "Xcode" = 497799835;
      "Photomator" = 1444636541;
    };

    taps = [
      {
        name = "bwees/tap";
        trusted = true;
      }
      {
        name = "TheBoredTeam/boring-notch";
        trusted = true;
      }
    ];

    brews = [
      "mas"
      "cocoapods"
      "mise"

      # xcode/swift devtools
      "xcode-build-server"
      "xcodegen"
      "swiftgen"
      "swiftlint"
      "swiftformat"
      "xcbeautify"
    ];
  };

  # Nix Package Store
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    _1password-cli
    btop
    gh
    yt-dlp
    ffmpeg
    wget
    nmap
    duti
    restic
    rsync
    android-tools
    claude-code
    just

    R

    # nix tools/lsp
    nil
    nixd
    nixfmt

    # NixOS Rebuild CLI
    nixos-rebuild

    # orcaslicer build deps
    cmake
    gettext
    libtool
    automake
    autoconf
    texinfo

    # kubernetes
    k3d
    k9s
    fluxcd

    platformio-core
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
