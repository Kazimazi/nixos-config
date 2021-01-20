{ config, pkgs, ... }:

{
  security.rtkit.enable = true; # ?

  nixpkgs.config.pulseaudio = true;
  #hardware.pulseaudio.enable = true;
  hardware.pulseaudio.enable = pkgs.lib.mkForce false;

  environment.systemPackages = with pkgs; [
    pavucontrol
    qjackctl
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
