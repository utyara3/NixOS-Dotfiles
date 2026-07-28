# nixos/configutaion.nix

{
  pkgs,
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

    # Services
    ./services/virtualisation.nix
    ./services/happ.nix
    ./services/power.nix
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;

    trusted-users = [
      "root"
      "@wheel"
    ];

    keep-outputs = true;
    keep-derivations = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      Policy = {
        AutoEnable = false;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = "/home/utyara3/nixos-config";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
  };

  programs.steam.enable = true;
  programs.gamescope.enable = true;

  services.gnome.gnome-keyring.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
