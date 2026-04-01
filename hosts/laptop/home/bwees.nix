{
  config,
  inputs,
  lib,
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
        pnpm = "latest";
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
          "0=#1e1e1e"
          "1=#f44747"
          "2=#6a9955"
          "3=#d7ba7d"
          "4=#569cd6"
          "5=#c586c0"
          "6=#9cdcfe"
          "7=#d4d4d4"
          "8=#808080"
          "9=#d16969"
          "10=#b5cea8"
          "11=#ce9178"
          "12=#007acc"
          "13=#646695"
          "14=#6796e6"
          "15=#d4d4d4"
        ];
      };
    };
  };
}
