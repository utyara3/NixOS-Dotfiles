# nixos/desktop/audio.nix

{ ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # For Sonic Pi
    jack.enable = true;
  };
}
