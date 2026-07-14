{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    vim
    wget
    curl
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
