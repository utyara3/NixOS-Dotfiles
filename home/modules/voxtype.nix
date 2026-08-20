{ inputs, pkgs, ... }:

{
  imports = [
    inputs.voxtype.homeManagerModules.default
  ];

  programs.voxtype = {
    enable = true;

    # Whisper + Vulkan
    package = inputs.voxtype.packages.${pkgs.system}.vulkan;

    # Мультиязычная модель
    model.name = "small";

    # Запускаем daemon через systemd --user
    service.enable = true;

    settings = {
      hotkey.enabled = false;

      whisper = {
        language = "auto";
        translate = false;
        on_demand_loading = true;
      };

      output = {
        mode = "type";
        fallback_to_clipboard = true;
        type_delay_ms = 0;
      };

      output.notification = {
        on_recording_start = false;
        on_recording_stop = false;
        on_transcription = true;
      };
    };
  };
}
