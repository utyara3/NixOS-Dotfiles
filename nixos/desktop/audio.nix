# nixos/desktop/audio.nix
{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Добавляем pipewire.jack в систему, чтобы утилита pw-jack была доступна
  environment.systemPackages = with pkgs; [
    pipewire.jack
  ];

  # Создаем глобальный безопасный алиас: при вызове sonic-pi он автоматически запустится через pw-jack
  environment.shellAliases = {
    sonic-pi = "pw-jack sonic-pi";
  };
}
