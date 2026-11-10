# nixos/services/minecraft-lan.nix

{ ... }: {

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };
}
