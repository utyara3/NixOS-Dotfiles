{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
    ./modules/git.nix
    ./modules/xdg.nix
    ./modules/niri.nix
    ./modules/theme.nix
  ];
  
  home.username = "utyara3";
  home.homeDirectory = "/home/utyara3";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    DBX_CONTAINER_MANAGER = "podman";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    neovim
    discord

    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.ayugram-desktop.packages."${pkgs.stdenv.hostPlatform.system}".default

    podman
    docker
    docker-compose
    lazydocker
  ];
}

