# home/packages/dev.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    # neovim
    (code-cursor.override {
      commandLineArgs = "--password-store=\"gnome-keyring\"";
    })

    # Containers
    podman
    docker
    docker-compose
    lazydocker

    # Uv
    uv
  ];
}
