{ config, inputs, pkgs, ... }:

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
    };
  };
}