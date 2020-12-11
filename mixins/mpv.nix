{ config, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.mpv = {
        enable = true;
      };
    };
  };
}
