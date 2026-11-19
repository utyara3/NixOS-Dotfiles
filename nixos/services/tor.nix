{ pkgs, ... }:

{
  services.tor = {
    enable = true;

    # Включаем локальный SOCKS5-прокси на 127.0.0.1:9050
    client = {
      enable = true;
    };

    # Настройка Hidden Service (.onion-сайт для локального проекта)
    # relay.onionServices = {
    #   "go-pet-project" = {
    #     version = 3;
    #     map = [
    #       {
    #         port = 80;
    #         target = {
    #           addr = "127.0.0.1";
    #           port = 8080; # Порт, на котором крутится сервер
    #         };
    #       }
    #     ];
    #   };
    # };

    # Обход блокировок в РФ через мосты
    settings = {
      UseBridges = true;
      ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
      # мосты из Telegram-бота @GetBridgesBot
      Bridge = [
        # "obfs4 IP:PORT FINGERPRINT cert=... iat-mode=0"
      ];
    };
  };

  # Устанавливаем obfs4proxy в систему, чтобы Tor мог его вызывать
  environment.systemPackages = with pkgs; [
    obfs4
  ];
}
