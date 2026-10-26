# nixos/desktop/display.nix

{ pkgs, inputs, ... }:

{
  # Нужно для того чтобы Happ (и прочие) запускались
  # Без ошибки wayland окружения
  services.xserver = {
    enable = true;

    xkb = {
      layout = "us,ru";
      options = "grp:caps_toggle";
    };
  };

  # GDM (экран входа в систему от GNOME)
  services.displayManager.gdm.enable = true;

  # Noctalia greeter (экран входа в систему от Noctalia)
  services.displayManager.noctalia-greeter = {
    enable = false;
    settings = {
      keyboard.layout = "us,ru";
    };
  };

  services.displayManager.defaultSession = "umbriel";

  # Применяем в tty
  console.useXkbConfig = true;

  # GNOME (если понадобится - раскомментировать)
  # services.desktopManager.gnome.enable = true;

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.gdm
  ];

  # Включаем Thunar на уровне системы
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin # Сжать/Распаковать в контекстном меню
      thunar-volman # Автоматическое управление флешками
    ];
  };

  # Службы для корректной работы файловых менеджеров
  services.gvfs.enable = true; # Корзина, монтирование дисков, MTP для телефонов
  services.tumbler.enable = true; # Генерация миниатюр (картинок) для Thunar и Yazi
  programs.xfconf.enable = true; # Чтобы Thunar сохранянь свои настройки (тему, вид)

}
