{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xwayland-satellite

    git
    vim
    wget
    curl
    htop
    btop
    tree
    fastfetch

    wireplumber
    brightnessctl
    playerctl
    cliphist
    wl-clipboard
    obsidian
    yazi
  ];
}
