# nixos/services/power.nix

{ ... }:

{
  services.upower.enable = true;

  services.dbus.enable = true;
}
