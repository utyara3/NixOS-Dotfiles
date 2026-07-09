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
  ];
}
