# home/packages/core.nix

{ pkgs, inputs, ... }:

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

    # Calculator
    qalculate-gtk

    # File manager
    yazi

    # Apps
    obsidian
    gimp
    libreoffice
    zathura

    # Gnome archive
    file-roller

    # Mouseless utility
    warpd

    # Panel (Noctalia)
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
