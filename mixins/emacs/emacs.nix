{ config, lib, pkgs, inputs, ... }:

{
  config = {
    nixpkgs.overlays = [ inputs.emacs.overlay ];
    #services.emacs.enable = true;
    #services.emacs.package = pkgs.emacsGcc;
    environment.systemPackages = with pkgs; [
      #emacsGcc
      emacsPgtkGcc
      #(
      #  emacsWithPackagesFromUsePackage {
      #    # Your Emacs config file. Org mode babel files are also
      #    # supported.
      #    # NB: Config files cannot contain unicode characters, since
      #    #     they're being parsed in nix, which lacks unicode
      #    #     support.
      #    # config = ./emacs.org;
      #    config = ./init.el;

      #    # Package is optional, defaults to pkgs.emacs
      #    #package = pkgs.emacsGcc; # BUG https://github.com/NixOS/nixpkgs/pull/109370
      #    package = pkgs.emacsGit;

      #    # By default emacsWithPackagesFromUsePackage will only pull in
      #    # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
      #    # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
      #    # and pulls in all use-package references not explicitly disabled via
      #    # `:ensure nil` or `:disabled`.
      #    # Note that this is NOT recommended unless you've actually set
      #    # `use-package-always-ensure` to `t` in your config.
      #    alwaysEnsure = true;

      #    # For Org mode babel files, by default only code blocks with
      #    # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
      #    # will include all code blocks missing the `:tangle` argument,
      #    # defaulting it to `yes`.
      #    # Note that this is NOT recommended unless you have something like
      #    # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
      #    # which defaults `:tangle` to `yes`.
      #    alwaysTangle = false;

      #    # Optionally provide extra packages not in the configuration file.
      #    extraEmacsPackages = epkgs: [ ];
      #  }
      #)
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
