# nixos/desktop/display.nix

{ config, pkgs, ...}:

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
  services.desktopManager.gnome.enable = true;
}
