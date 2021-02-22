{ config, pkgs, ... }:

{
  config = {
    users.users.kazimazi.extraGroups = ["adbusers"];
    programs.adb.enable = true;
  };
}
