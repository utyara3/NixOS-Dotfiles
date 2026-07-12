{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    vim
    wget
    curl
    htop
    btop
    tree
    fastfetch
    acpi
    upower

    # Wayland essentials
    wl-clipboard
    xwayland-satellite
  ];
}
