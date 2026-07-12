# nixos/configutaion.nix

{ config, pkgs, inputs, ... }:

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

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
