{ config, lib, pkgs, inputs, ... }:
# TODO write common-init.vim for neovim/vscode collab

{
  config = {
    nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ];
    home-manager.users.kazimazi = { pkgs, ... }:
      let
        vimdiff = "nvim -d";
        vim = "nvim";
      in {
        programs.bash.shellAliases = {
          vimdiff = "nvim -d";
          vim = "nvim";
        };
        programs.zsh.shellAliases = {
          vimdiff = "nvim -d";
          vim = "nvim";
        };
        programs.fish.shellAliases = {
          vimdiff = "nvim -d";
          vim = "nvim";
        };

        programs.bat = { enable = true; };
        home = {
          packages = with pkgs; [
            neovim-nightly
            nodejs
            python
            # TODO I should really make a package pack thingy for Lang Servers and friends.
            # TODO for fzf search utils but I already have a mixin for it so shouldn't I just import that?
            fzf ripgrep

            # idk if I need any of this
            clang-tools gcc

            # for telescope
            bat fd

            # for nvim built in lsp
            nodePackages.diagnostic-languageserver
          ];
          file = {
            ".config/nvim/".recursive = true;
            ".config/nvim/".source = ./nvim;
          };
        };
      };
  };
}
