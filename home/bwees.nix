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

      # Starforge hosts
      "starforge-docker" = {
        user = "starforge";
      };
      "starforge-pc" = {
        user = "root";
      };
    };
  };

  programs.git = {
    enable = true;
    userEmail = "brandonwees@gmail.com";
    userName = "bwees";
    lfs.enable = true;

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };

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

    settings = {
      experimental = true;
      verbose = false;
      auto_install = true;
    };

    globalConfig = {
      tools = {
        node = "lts";
        python = "3.13";
        ansible = "latest";
        pipx = "latest";
        just = "latest";
        typst = "latest";
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
      theme = "atom-one-dark";
    };

    themes = {
      atom-one-dark = {
        background = "1e2127";
        foreground = "abb2bf";

        palette = [
          "0=#1e2127"
          "1=#e06c75"
          "2=#98c379"
          "3=#d19a66"
          "4=#61afef"
          "5=#c678dd"
          "6=#56b6c2"
          "7=#abb2bf"
          "8=#5c6370"
          "9=#e06c75"
          "10=#98c379"
          "11=#d19a66"
          "12=#61afef"
          "13=#c678dd"
          "14=#56b6c2"
          "15=#ffffff"
        ];
      };
    };
  };
}
