# home/packages/core.nix

{ config, pkgs, inputs, ...}:

{
  home.packages = with pkgs; [
    # Utilites
    brightnessctl
    playerctl
    cliphist
    eza
    tty-clock

    # Calculator
    qalculate-gtk

    # File manager
    yazi

    # Apps
    obsidian
    gimp
    libreoffice
    zathura

    # Panel (Noctalia)
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
