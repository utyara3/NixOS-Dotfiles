# home/modules/ghostty.nix

{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true; # Корректная интеграция с вашим Zsh

    settings = {
      # Background & Transparency
      background-opacity = 0.65;
      background-blur = true; # Аппаратное размытие работает прямо из коробки!

      # Fonts
      font-family = "Fira Code Nerd Font";
      font-size = 12;
      # Ghostty автоматически подхватывает bold/italic для указанного семейства шрифтов

      # Cursor Customization
      cursor-style = "block";
      cursor-blink = true;
      # Примечание: "Шлейф" курсора (cursor_trail) в Ghostty реализуется через шейдеры.
      # По умолчанию он выключен, но шрифты и перемещения и так очень плавные.

      # Window Layout & Padding
      # Чтобы текст не прилипал к краям, делаем приятные аккуратные отступы:
      window-padding-x = 10;
      window-padding-y = 10;
      window-padding-balance = true;

      # Размеры окна при старте (в символах, Ghostty использует этот стандарт)
      window-width = 120;
      window-height = 35;

      # Отключаем классические рамки и заголовки окна, так как вы сидите на Niri
      window-decoration = false;

      # Tab Bar Customization
      # Ghostty использует красивые нативные вкладки операционной системы / WM
      background-tabs-associated = true;

      # Audio Bell
      desktop-notifications = false;
      command = "zsh"; # Сразу запускаем ваш любимый zsh
    };
  };
}
