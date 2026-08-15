# nixos/desktop/display.nix

{ pkgs, ... }:

{
  # Нужно для того чтобы Happ (и прочие) запускались
  # Без ошибки wayland окружения
  services.xserver.enable = true;

  # GDM (экран входа в систему)
  services.displayManager.gdm = {
    enable = true;
  };

  # Раскладки и Shift+Alt переключение
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.options = "grp:alt_shift_toggle";

  # GNOME (если понадобится - раскомментировать)
  # services.desktopManager.gnome.enable = true;

  # Включаем Thunar на уровне системы
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin # Сжать/Распаковать в контекстном меню
      thunar-volman # Автоматическое управление флешками
    ];
  };

  # Службы для корректной работы файловых менеджеров
  services.gvfs.enable = true; # Корзина, монтирование дисков, MTP для телефонов
  services.tumbler.enable = true; # Генерация миниатюр (картинок) для Thunar и Yazi
  programs.xfconf.enable = true; # Чтобы Thunar сохранянь свои настройки (тему, вид)

}
