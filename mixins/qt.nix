
{ config, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      qt = {
        enable = true;
        platformTheme = "gtk";
      };
    };
  };
}
