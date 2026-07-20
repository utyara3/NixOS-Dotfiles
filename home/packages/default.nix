# home/packages/default.nix

{ ... }:

{
  imports = [
    ./core.nix
    ./dev.nix
    ./media.nix
    ./social.nix
  ];
}
