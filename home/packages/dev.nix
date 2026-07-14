# home/packages/dev.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    # neovim

    # Containers
    podman
    docker
    docker-compose
    lazydocker

    # Uv
    uv
  ];
}
