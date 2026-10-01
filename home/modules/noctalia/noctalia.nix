# home/modules/noctalia/noctalia.nix

{ ... }:

{
  programs.noctalia = {
    enable = true;

    # Автоматически подргужаем настройки из импортированного toml-файла
    settings = builtins.fromTOML (builtins.readFile "${./noctalia-config.toml}");
  };
}
