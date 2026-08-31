# nixos/networking.nix

{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
}
