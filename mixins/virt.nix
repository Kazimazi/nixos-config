{ config, lib, pkgs, ... }:

{
  config = {
    virtualisation.libvirtd.enable = true;
    users.users.kazimazi.extraGroups = [ "libvirtd" ];
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
