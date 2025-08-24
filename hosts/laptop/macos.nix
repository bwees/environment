{ config, pkgs, ... }:

let
  user = config.system.primaryUser;
in
{

  users.users.bwees.home = "/Users/${user}";

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
      "/Users/${user}/Applications/Autodesk Fusion.app"
      "/System/Applications/iPhone Mirroring.app"
    ];

    persistent-others = [
      "/Users/${user}/Downloads"
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
    ".GlobalPreferences"."com.apple.mouse.scaling" = 1.0;

    CustomUserPreferences = {
      "com.apple.driver.AppleBluetoothMultitouch.mouse" = {
        MouseButtonMode = "TwoButton";
      };

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
      # keybindings
      # Script to export symbolic hotkey configs from MacOS
      # https://gist.github.com/sawadashota/8e7ce32234e0f07a03e955f22ec4c0f9
      # Screenshot selected area to file with Cmd+Option+Shift+4
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "30" = {
            enabled = true;
            value = {
              parameters = [
                52
                21
                1441792
              ];
              type = "standard";
            };
          };
          # Screenshot selected area to clipboard with Cmd+Shift+4
          "31" = {
            enabled = true;
            value = {
              parameters = [
                52
                21
                1179648
              ];
              type = "standard";
            };
          };
        };
      };
    };
  };

  imports = [
    ../../resources/ca.nix
  ];
}
