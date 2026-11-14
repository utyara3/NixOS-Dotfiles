# nixos/services/v2raya.nix

{ ... }: {

  services.v2raya.enable = false;

  networking.firewall = {
    allowedTCPPorts = [ 2017 ];
  };
}
