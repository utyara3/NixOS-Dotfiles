# home/modules/foot.nix

{ ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "Fira Code Nerd Font:size=12";

        initial-window-size-chars = "120x35";
        # initial-window-width = "1200";
        # initial-window-height = "750";

        pad = "0x0";
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

      colors = {
        # Прозрачность фона в процентах
        # Формат: AARRGGBB (Alpha, Red, Green, Blue)
        # a6 в начале задает ~65% непрозрачности (0.65). 000000 - черный цвет фона.
        background = "a6000000";

        # Цвет текста (белый по умолчанию, можете заменить на свой)
        foreground = "ffffff";
      };
    };
  };
}
