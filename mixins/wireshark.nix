{ config, lib, pkgs, ... }:

{
  config = {
    users.users.kazimazi.extraGroups = ["wireshark"];
    # information security & friends
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
