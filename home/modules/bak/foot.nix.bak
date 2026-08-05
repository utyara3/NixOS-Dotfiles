# home/modules/foot.nix

{ ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;

    settings = {
      main = {
        font = "Fira Code Nerd Font:size=12:rgba=rbg:hintstyle=slight";
        initial-window-size-chars = "120x35";
        pad = "10x10";
        term = "xterm-256color";
      };

      scrollback = {
        lines = "5000";
      };

      cursor = {
        style = "block";
        blink = "yes";
        blink-rate = "500";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      # Прозрачность терминала
      "colors-dark" = {
        # Задаем прозрачность через alpha
        alpha = "0.65";

        background = "000000";
        foreground = "ffffff";
      };
    };
  };
}
