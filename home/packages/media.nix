# home/packages/media.nix

{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.firefox
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];
}
