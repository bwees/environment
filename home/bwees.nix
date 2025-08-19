{
  config,
  inputs,
  pkgs,
  ...
}:

{

  home.stateVersion = "25.11";

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
}
