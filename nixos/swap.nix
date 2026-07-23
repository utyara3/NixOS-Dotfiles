# nixos/swap.nix

{ ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 24 * 1024;
    }
  ];
}
