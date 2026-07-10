{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./desktop.nix
    ./users.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # nix.settings = {
  #  max-jobs = 1;
  #  cores = 4;
  #};

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 24 * 1024;
  } ];

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  virtualisation.docker.enable = true;

  virtualisation.podman.enable = true;
}
