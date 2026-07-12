# nixos/desktop/fonts.nix

{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    noto-fonts
    noto-fonts-color-emoji
    
    fira-code
    fira-code-symbols
  ];
}
