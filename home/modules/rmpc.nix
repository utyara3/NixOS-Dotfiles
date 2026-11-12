{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rmpc
  ];

  # Фоновый плеер MPD (демон)
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
  };

  # Мост для виджетов Noctalia и медиа-клавиш
  services.mpd-mpris = {
    enable = true;
  };
}
