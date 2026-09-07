# nixos/configutaion.nix

{ pkgs, ... }:

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
    ./services/tlp.nix
    ./services/v2rayA.nix
    ./services/flatpak.nix
  ];

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

    substituters = [
      "https://cache.nixos.org/"
      "https://ayugram-desktop.cachix.org"
      "https://tg-owt.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA="
      "tg-owt.cachix.org-1:lp0BukIhSK3EIyLcDhDZ5zABgT48nmNp6t4SnZ0wr8w="
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        Policy = {
          AutoEnable = false;
        };
      };
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vulkan-loader
        intel-compute-runtime
      ];
    };

    uinput.enable = true;
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

  programs = {
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;

    throne = {
      enable = true;
      tunMode.enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/utyara3/nixos-config";
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        openssl
        curl
        libssh2
        glibc
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
