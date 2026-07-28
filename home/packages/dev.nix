# home/packages/dev.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    # neovim
    code-cursor

    # Containers
    podman
    docker
    docker-compose
    lazydocker

    # Uv
    uv
  ];
}
