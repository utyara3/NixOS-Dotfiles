# home/modules/noctalia/noctalia.nix

{ inputs, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    # Автоматически подргужаем настройки из импортированного toml-файла
    settings = builtins.fromTOML (builtins.readFile ./noctalia-config.toml);
  };
}
