{ config, lib, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [ git ];
    #home-manager.users.kazimazi = { pkgs, ... }: {
    #  programs.git = {
    #    enable = true;
    #    userEmail = "attila.koszo.official@gmail.com";
    #    userName = "kazimazi";
    #  };
    #};
  };
}
