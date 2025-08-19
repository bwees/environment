{ config, pkgs, ... }:

{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Chromium.app"
      "/Applications/Spark.app"
      "/Applications/Discord.app"
      "/System/Applications/Messages.app"
      "/Applications/Goodnotes.app"
      "/Applications/Notion.app"
      "/System/Applications/System Settings.app"
      "/System/Applications/Calendar.app"
      "/Applications/Spotify.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Xcode.app"
      "/Applications/Ghostty.app"
      "/Users/${config.system.primaryUser}/Applications/Autodesk Fusion.app"
    ];

    persistent-others = [
      "/Users/${config.system.primaryUser}/Downloads"
    ];

    tilesize = 42;
    show-recents = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;

  system.defaults = {
    finder.FXPreferredViewStyle = "Nlsv";
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    LaunchServices.LSQuarantine = false; # disables "Are you sure?" for new apps
    loginwindow.GuestEnabled = false;

    CustomUserPreferences = {
      "com.apphousekitchen.aldente-pro" = {
        menuBarIconStyle = 2;
        heatProtectMode = true;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
    };
  };

  imports = [
    ../../resources/ca.nix
  ];
}
