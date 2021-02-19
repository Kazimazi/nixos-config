{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
      };
    };
  };
}

