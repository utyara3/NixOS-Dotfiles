# home/packages/media.nix

{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];
}
