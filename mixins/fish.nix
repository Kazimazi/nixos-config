{ config, lib, pkgs, ... }:

{
  imports = [ ];
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs = {
        fish = {
          enable = true;
          shellInit = ''
            fish_vi_key_bindings
          '';
        };
      };
    };
  };
}
