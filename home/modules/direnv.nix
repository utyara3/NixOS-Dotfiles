# home/modules/direnv.nix

{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    silent = true;

    config = {
      global = {
        hide_env_diff = true;
        log_format = "-";
      };
    };
  };
}
