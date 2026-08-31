# home/modules/voxtype.nix

{ inputs, pkgs, ... }:

{
  imports = [
    inputs.voxtype.homeManagerModules.default
  ];

  programs.voxtype = {
    enable = true;
    package = inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;

    model.name = "small";
    service.enable = true;

    settings = {
      hotkey.enabled = false;

      osd = {
        fronted = "gtk4";
        enable = true;
      };

      whisper = {
        language = "ru";
        translate = false;
        on_demand_loading = false;
      };

      output = {
        mode = "type";
        fallback_to_clipboard = true;
        type_delay_ms = 0;
      };
    };
  };
}
