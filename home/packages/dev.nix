# home/packages/dev.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Containers
    docker
    docker-compose
    lazydocker

    nixfmt
  ];
}
