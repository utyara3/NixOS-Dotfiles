# home/modules/noctalia/noctalia.nix

{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    # Автоматически подргужаем настройки из импортированного toml-файла
    settings = builtins.fromTOML (builtins.readFile "${./noctalia-config.toml}");
  };
}
