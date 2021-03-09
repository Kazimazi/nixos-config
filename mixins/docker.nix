{ config, lib, pkgs, ... }:

{
  config = {
    virtualisation.docker.enable = true;
    users.users.kazimazi.extraGroups = [ "docker" ];
  };
}
