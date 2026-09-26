# home/packages/core.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Utilites
    brightnessctl
    playerctl
    cliphist
    eza
    tty-clock
    cmatrix
    pipes-rs
    mpv
    imv

    # Calculator
    qalculate-gtk

    # File manager
    file
    yazi

    # Apps
    obsidian
    gimp
    libreoffice
    kdePackages.okular
    localsend
    tor-browser
    sonic-pi

    # Gnome archive
    file-roller

    # Kiwix
    kiwix
    kiwix-tools
  ];
}
