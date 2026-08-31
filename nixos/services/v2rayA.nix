# nixos/services/v2raya.nix

{ ... }: {

  services.v2raya.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 2017 ];
  };
}
