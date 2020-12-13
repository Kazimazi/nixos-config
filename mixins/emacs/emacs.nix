{ config, lib, pkgs, inputs, ... }:

{
  config = {
    # TODO not working? why?
    #environment.systemPackages = with pkgs; [(emacsWithPackagesFromUsePackage {
    #  config = ./init.el;
    #  package = pkgs.emacsPgtkGcc;
    #  alwaysEnsure = true;
    #})];

    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.emacs = {
        enable = true;
        package = pkgs.emacsGcc;
      };
    };
  };
}
