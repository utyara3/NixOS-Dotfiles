{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # Отключить логи
    silent = true;
  };
}
