{ config, pkgs, ... }:

{
  programs.qalculate = {
    enable = true;
    settings = {
      # Секция для общих настроек (автообновление валют)
      General = {
        update_exchange_rates = 1; # Использовать 1 (true) или 0 (false)
      };
      # Секция для режима вычислений (точка для дробей)
      Mode = {
        decimal_separator = ".";
      };
    };
  };
}
