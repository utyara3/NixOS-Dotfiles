# home/home.nix

{ inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
    inputs.nixvim.homeModules.nixvim

    ./modules/noctalia/noctalia.nix

    ./modules/git.nix
    ./modules/xdg.nix
    ./modules/niri.nix
    ./modules/theme.nix
    ./modules/kitty.nix
    ./modules/zsh.nix
    ./modules/fastfetch.nix
    ./modules/direnv.nix
    ./modules/nixvim.nix
    ./modules/qalc.nix
    ./modules/obs.nix
    ./modules/yazi.nix

    ./packages # default.nix
  ];

  home.username = "utyara3";
  home.homeDirectory = "/home/utyara3";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    DBX_CONTAINER_MANAGER = "podman";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.home-manager.enable = true;
}
