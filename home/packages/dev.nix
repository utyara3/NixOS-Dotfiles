# home/packages/dev.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editor
    # neovim
    (code-cursor.override {
      commandLineArgs = [
        "--password-store=basic"
        "--ozone-platform-hint=auto"
        "--enable-features=WaylandWindowDecorations"
      ];
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
