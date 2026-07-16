# nixos/configutaion.nix

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    # Core system
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./swap.nix
    ./users.nix
    ./packages.nix

    # Desktop
    ./desktop/display.nix
    ./desktop/niri.nix
    ./desktop/audio.nix
    ./desktop/fonts.nix
    ./desktop/direnv.nix

    # Services
    ./services/virtualisation.nix
    ./services/happ.nix
    ./services/power.nix
  ];

  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  programs.steam = {
    enable = true;
  };
  programs.gamescope.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
