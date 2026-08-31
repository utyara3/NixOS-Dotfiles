# home/modules/opencode.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    opencode
  ];
}
