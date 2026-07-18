{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    vim
    wget
    curl
    unzip
    imv
    mpv
    bluez
    htop
    btop
    tree
    fastfetch
    acpi
    upower
    ripgrep
    direnv
    nix-direnv
    uv

    # Wayland essentials
    wl-clipboard
    xwayland-satellite
  ];
}
