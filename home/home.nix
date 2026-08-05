# home/home.nix

{ inputs, lib, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
    inputs.nixvim.homeModules.nixvim

    ./modules/noctalia/noctalia.nix

    ./packages
  ]
  ++ (builtins.map (name: ./modules + "/${name}") (
    builtins.attrNames (
      lib.attrsets.filterAttrs (name: type: type == "regular" && lib.strings.hasSuffix ".nix" name) (
        builtins.readDir ./modules
      )
    )
  ));

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
