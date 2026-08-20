{ inputs, pkgs, ... }:

{
  imports = [
    inputs.voxtype.homeManagerModules.default
  ];

  programs.voxtype = {
    enable = true;
    package = inputs.voxtype.packages.${pkgs.system}.vulkan;

    model.name = "base";
    service.enable = true;

    settings = {
      hotkey.enabled = false;

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
