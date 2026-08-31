# home/modules/direnv.nix

{ ... }:

{
  programs.direnv = {
    enable = true;
    # Устанавливает direnv и автоматически настривает необходимые shell hooks
    nix-direnv.enable = true;

    # Отключает стандартные сообщения direnv
    silent = true;

    config = {
      global = {
        # Скрывает список измененных переменных окружения
        hide_env_diff = true;

        # Задает пустой формат для системных логов direnv
        # Символ "-" окончательно убирает префиксы логов
        log_format = "-";
      };
    };
  };
}
