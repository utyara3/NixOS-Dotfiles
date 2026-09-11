# home/modules/theme.nix

{ pkgs, ... }:

{
  # Настройка курсора (Bibata — отличный выбор, оставляем)
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  # Настройка GTK окружения для красивых и мягких приложений
  gtk = {
    enable = true;

    # Используем Adw-gtk3, чтобы старые GTK3 приложения имели
    # такие же круглые углы и плоский пастельный вид, как новые GTK4/Libadwaita приложения
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    # Ставим пастельные и аккуратные иконки (MoreWaita отлично подходит под круглый стиль)
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };

    # Мягкие, скругленные шрифты для интерфейсов приложений
    font = {
      name = "Inter Display";
      package = pkgs.inter;
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Заставляем QT-приложения выглядеть так же, как GTK (использовать системную тему)
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };
}
