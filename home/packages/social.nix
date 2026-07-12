# home/packages/social.nix

{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.discord
    inputs.ayugram-desktop.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];
}
