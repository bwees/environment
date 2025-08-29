{ config, pkgs, ... }:

{
  homebrew = {
    taps = [
      "CQLabs/dcm"
    ];

    brews = [
      "dcm"
      "nvm"
    ];
  };

  environment.systemPackages = with pkgs; [
    dart
    pnpm
    cocoapods

    # immich-retro dvd build
    dvdauthor
    cdrtools
  ];
}