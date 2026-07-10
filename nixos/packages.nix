{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
