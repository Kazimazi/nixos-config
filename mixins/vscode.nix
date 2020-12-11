{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.vscode = {
        enable = true;
        #package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [ vscodevim.vim ];
        userSettings = {
          "keyboard.dispatch" = "keyCode";
          "editor.minimap.enabled" = false;
        };
      };
    };
  };
}

