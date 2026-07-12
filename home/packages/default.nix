# home/packages/default.nix

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./core.nix
    ./dev.nix
    ./media.nix
    ./social.nix
  ];
}
