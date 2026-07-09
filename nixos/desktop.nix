{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:alt_shift_toggle";
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
}
