{ config, pkgs, inputs, ... }:

{
  # Xserver and gdm (login screen)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  
  # GNOME (SHIT)
  services.desktopManager.gnome.enable = true;
  
  # System keyboard (for gdm)
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:alt_shift_toggle";

  # NIRI :))
  programs.niri.enable = true;

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.kitty
  ];
}
