{ config, lib, pkgs, inputs, ... }:

{
  config = {
    nixpkgs.overlays = [ inputs.emacs.overlay ];
    #services.emacs.enable = true;
    #services.emacs.package = pkgs.emacsGcc;
    environment.systemPackages = with pkgs; [
      #emacsGcc
      #emacsPgtkGcc
      emacsGit
      ripgrep
      python3 # for treemacs
    ];

    home-manager.users.kazimazi = { pkgs, ... }: {
      home.file = {
        ".config/emacs/early-init.el".source = (pkgs.writeText "early-init"
          (builtins.readFile ./early-init.el));
        ".config/emacs/init.el".source = (pkgs.writeText "init"
          (builtins.readFile ./init.el));
      };
    };
  };
}
