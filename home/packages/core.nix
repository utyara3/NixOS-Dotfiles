# home/packages/core.nix

{ config, pkgs, inputs, ...}:

{
  home.packages = with pkgs; [
    # Utilites
    brightnessctl
    playerctl
    cliphist

    # File manager
    yazi

    # Apps
    obsidian

    # Panel (Noctalia)
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
