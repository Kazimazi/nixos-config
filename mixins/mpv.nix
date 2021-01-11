{ config, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.packages = with pkgs; [
        master.mpv
      ];
      programs.mpv = {
        enable = false; # BROKEN on nixpkgs-unstable
        package = pkgs.mpv; # NOTE can't be changed??? why?
      };
    };
  };
}
