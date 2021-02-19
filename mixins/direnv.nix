{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs = {
        direnv.enable = true;
        direnv.enableNixDirenvIntegration = true;
      };
    };
  };
}
