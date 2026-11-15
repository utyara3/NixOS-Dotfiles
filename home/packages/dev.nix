# home/packages/dev.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Containers
    docker
    docker-compose
    lazydocker

    nixfmt

    # Translator
    dialect

    # Remote desk
    rustdesk-flutter

    # Web
    bruno
    bruno-cli
    python3Packages.locust

    # .NET SDK 10
    dotnetCorePackages.sdk_10_0

    # Github
    github-desktop
  ];
}
