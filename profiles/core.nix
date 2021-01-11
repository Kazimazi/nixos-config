{ config, lib, pkgs, ... }:

{
  imports = [
    ../mixins/neovim.nix
    ../mixins/emacs/emacs.nix
    ../mixins/git.nix
    ../mixins/fish.nix
    ../mixins/tmux.nix
  ];
  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.sessionVariables = {
        EDITOR = "vim";
      };
      home.stateVersion = "20.09";
    };
  };
}
