{ config, pkgs, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    pictures = "${config.home.homeDirectory}/Pictures";
    music = "${config.home.homeDirectory}/Music";
    desktop = "${config.home.homeDirectory}/Desktop";
  };
}
