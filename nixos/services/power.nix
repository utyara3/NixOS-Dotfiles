# nixos/services/power.nix

{ config, pkgs, ...}:

{
  services.upower.enable = true;

  services.dbus.enable = true;
}
