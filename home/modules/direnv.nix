# home/modules/direnv.nix

{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
