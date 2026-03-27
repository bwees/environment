{
  config,
  inputs,
  pkgs,
  ...
}:

{

  home.stateVersion = "25.11";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      StrictHostKeyChecking no
    '';

    matchBlocks = {
      "*" = {
        extraOptions = {
          IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
          SetEnv = "TERM=xterm-256color";
        };
      };

      # Homelab hosts
      "homelab-bwees" = {
        hostname = "homelab-bwees";
      };
      "homelab-home" = {
        hostname = "homelab-home";
      };
      "homelab-linode" = {
        hostname = "homelab-linode";
      };
      "bwees-nas" = {
        hostname = "bwees-nas";
        user = "root";
      };

      # Starforge hosts
      "starforge-server" = {
        user = "starforge";
      };
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        email = "brandonwees@gmail.com";
        name = "bwees";
      };

      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };

      core.editor = "code --wait";

      # 1P Commit Signing
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuYih7LaCHvoa+3P6GjKtGpSWci/qX1OMjKRFk+TbIq";
      gpg.format = "ssh";
      gpg."ssh" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      commit = {
        gpgsign = true;
      };
    };
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    initContent = builtins.readFile ./.zshrc;
  };

  imports = [
    ./starship.nix
  ];

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.writeShellScriptBin "mise" ''
      exec mise "$@"
    '';

    globalConfig = {
      tools = {
        node = "lts";
        python = "3.13";
        just = "latest";
      };
      settings = {
        experimental = true;
        verbose = false;
        auto_install = true;
        idiomatic_version_file_enable_tools = [ ];
      };
    };
  };

  # Ghostty
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = null;

    settings = {
      auto-update = "off";
      clipboard-paste-protection = false;
      theme = "vscode-dark";
    };

    themes = {
      vscode-dark = {
        background = "1e1e1e";
        foreground = "d4d4d4";

        palette = [
          "0=#000000"
          "1=#cd3131"
          "2=#0dbc79"
          "3=#e5e510"
          "4=#2472c8"
          "5=#bc3fbc"
          "6=#11a8cd"
          "7=#e5e5e5"
          "8=#666666"
          "9=#f14c4c"
          "10=#23d18b"
          "11=#f5f543"
          "12=#3b8eea"
          "13=#d670d6"
          "14=#29b8db"
          "15=#e5e5e5"
        ];
      };
    };
  };
}
