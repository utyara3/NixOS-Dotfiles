# nixos/desktop/fonts.nix

{ pkgs, ... }:

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
