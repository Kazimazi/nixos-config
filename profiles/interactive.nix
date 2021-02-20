{ config, lib, pkgs, ... }:

{
  imports = [
    ./core.nix

    ../mixins/xdg.nix
    ../mixins/gpg.nix
    ../mixins/vifm/vifm.nix
    ../mixins/direnv.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [
      ripgrep
      fzf # emacs tramp couldn't use fzf, how about now?

      # information security & friends
      ncat
      nmap
    ];

    # HM: ca.desrt.dconf error:
    services.dbus.packages = with pkgs; [ gnome3.dconf ];

    # yuck
    programs.java = {
      enable = true;
    };

    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.fzf.enable = true;
      home.packages = with pkgs; [
        amfora

        glxinfo
        htop

        neofetch
        pciutils

        cmus

        (ghc.withPackages (hp: with hp; [ haskell-language-server ]))

        nodePackages.vim-language-server
        rnix-lsp
        sumneko-lua-language-server

        # alkfejlesztes stack
        maven

        # multimedia stack
        nodePackages.vscode-html-languageserver-bin
        nodePackages.vscode-css-languageserver-bin
        nodePackages.http-server
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages.eslint
        nodePackages.vscode-json-languageserver-bin

        youtube-dl
        ffmpeg

        sshfs

        ntfs3g

        xdg_utils

        unrar
        unzip
        zip
      ];
    };
  };
}
