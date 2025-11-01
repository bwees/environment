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
      "/Applications/GitButler.app"
      "/Applications/Xcode.app"
      "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
      "/Applications/Ghostty.app"
      "/Applications/OrcaSlicer.app"
      # "/Users/${user}/Applications/Autodesk Fusion.app"
      "/System/Applications/iPhone Mirroring.app"
    ];

    # persistent-others: see below in CustomUserPreferences

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

    CustomSystemPreferences = {
      "com.apple.DiskArbitration.diskarbitrationd" = {
        DADisableEjectNotification = true;
      };
    };

    CustomUserPreferences = {
      "com.apple.driver.AppleBluetoothMultitouch.mouse" = {
        MouseButtonMode = "TwoButton";
      };
      "com.apple.WindowManager" = {
        EnableTiledWindowMargins = false;
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

      # persistent-others does not currently support setting view type and sort
      # https://gist.github.com/kamui545/c810eccf6281b33a53e094484247f5e8
      "com.apple.dock" = {
        persistent-others = [
          {
            tile-data = {
              arrangement = 2;
              displayas = 0;
              file-data = {
                _CFURLString = "file:///Users/${user}/Downloads/";
                _CFURLStringType = 15;
              };
              file-type = 2;
              showas = 1;
            };
            tile-type = "directory-tile";
          }
        ];
      };
    };
  };

  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/activation-scripts.nix
  system.activationScripts.userDefaults.text = ''
    echo "setting macOS file defaults..."
    su -l ${config.users.users.bwees.name} -c '
      ${pkgs.duti}/bin/duti -s com.softfever3d.orca-slicer stl all
      ${pkgs.duti}/bin/duti -s com.autodesk.fusion360 step all
      ${pkgs.duti}/bin/duti -s com.readdle.smartemail-Mac mailto all
    '
  '';

  imports = [
    ../../lib/ca.nix
  ];
}
