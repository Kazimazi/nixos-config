{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pavucontrol ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    media-session.enable = true;
  };
  security.rtkit.enable = true;
}
