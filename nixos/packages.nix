{ pkgs, ... }:

let
  nr-rebuild = import ./services/rebuild-script.nix { inherit pkgs; };
in
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
    powertop

    # Wayland essentials
    wl-clipboard
    xwayland-satellite

    nr-rebuild
  ];
}
