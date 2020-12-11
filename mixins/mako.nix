{ config, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs = {
        mako.enable = true;
      };
    };
  };
}
