{ pkgs, ... }:

{
  services.postgresql = {
    enable = false;
    package = pkgs.postgresql_18;
  };
}
