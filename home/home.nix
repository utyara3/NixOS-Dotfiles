{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix
  ];
  
  home.username = "utyara3";
  home.homeDirectory = "/home/utyara3";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    neovim
  ];
}

