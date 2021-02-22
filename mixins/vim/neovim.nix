{ config, lib, pkgs, inputs, ... }:

{
  config = {
    nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ];
    home-manager.users.kazimazi = { pkgs, ... }:
      {
        programs = {
          neovim = {
            enable = true;
            package = pkgs.neovim-nightly;
            extraConfig = (builtins.readFile ./nvim/init.vim);
            withPython3 = true;
            withNodeJs = true;
            extraPackages = with pkgs; [
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
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
          };
        };

        programs.bat = { enable = true; };

        home = {
          file = {
            ".config/nvim/lua".recursive = true;
            ".config/nvim/lua".source = ./nvim/lua;
            ".config/nvim/coc-settings.json".source = ./nvim/coc-settings.json;
          };
        };
      };
  };
}
