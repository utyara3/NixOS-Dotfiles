# home/home.nix

{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
    ./modules/git.nix
    ./modules/xdg.nix
    ./modules/niri.nix
    ./modules/theme.nix
    ./modules/kitty.nix
    ./modules/zsh.nix
    ./modules/fastfetch.nix

    ./packages # default.nix
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
}

