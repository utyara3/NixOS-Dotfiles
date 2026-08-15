{ pkgs, ... }:

{
  home.packages = [ pkgs.bento ];

  # Создаем дефолтный пустой конфиг, чтобы Bento запустился.
  # Дальше ты сможешь настраивать всё прямо мышкой в браузере!
  xdg.configFile."bento/config.yml".text = ''
    theme: "tokyonight"
    groups:
      - name: "Моё важное"
        links:
          - name: "GitHub"
            url: "https://github.com"
  '';

  systemd.user.services.bento = {
    Unit = {
      Description = "Bento Dashboard";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.bento}/bin/bento";
      WorkingDirectory = "%h/.config/bento";
      Restart = "always";
      Environment = "PORT=7575";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
