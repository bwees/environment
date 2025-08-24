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
    extraConfig = ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        SetEnv TERM=xterm-256color
    '';
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

    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
      plugins = [ "git" ];
    };
  };

  # Ghostty
  home.file.ghostty-theme = {
    enable = true;
    source = ghostty/atom-one-dark;
    target = "./.config/ghostty/themes/atom-one-dark";
  };

  home.file.ghostty-config = {
    enable = true;
    source = ghostty/config;
    target = "./Library/Application Support/com.mitchellh.ghostty/config";
  };

}
