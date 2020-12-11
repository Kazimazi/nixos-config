{ config, lib, pkgs, ... }:

{
  imports = [ ];
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.packages = with pkgs; [
        taisei
      ];
    };
  };
}
