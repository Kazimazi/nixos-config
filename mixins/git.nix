{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.git = {
        enable = true;
        userEmail = "attila.koszo.official@gmail.com";
        userName = "kazimazi";
      };
    };
  };
}
