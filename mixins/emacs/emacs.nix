{ config, lib, pkgs, inputs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.emacs = {
        enable = true;
        #package = pkgs.emacsWithPackagesFromUsePackage {
        #  config = ./emacs.el;
        #  package = pkgs.emacsPgtkGcc;
        #  alwaysEnsure = true;
        #  alwaysTangle = false;
        #  extraEmacsPackages = epkgs: [
        #    epkgs.evil
        #  ];
        #};
        package = pkgs.emacsPgtkGcc;
      };
    };
  };
}

