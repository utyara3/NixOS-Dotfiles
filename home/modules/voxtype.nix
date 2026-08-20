{ pkgs, inputs, ... }:

{
  imports = [
    inputs.voxtype.homeManagerModules.default
  ];

  programs.voxtype = {
    enable = true;

    package = inputs.voxtype.packages.${pkgs.system}.default;

    model.name = "small";

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

      audio = {
        device = "default";
        sample_rate = 16000;
        max_duration_secs = 60;
      };

      audio.feedback = {
        enabled = true;
        theme = "subtle";
        volume = 0.5;
      };

      output.notification = {
        on_recording_start = false;
        on_recording_stop = false;
        on_transcription = true;
      };
    };
  };
}
