{ config, lib, pkgs, ... }:

{
  imports = [
    ./core.nix

    ../mixins/xdg.nix
    ../mixins/gpg.nix
    ../mixins/vifm/vifm.nix
    ../mixins/direnv.nix
    ../mixins/adb.nix
    #../mixins/docker.nix
    #../mixins/virt.nix
    ../mixins/nix-index.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [
      # information security & friends
      ncat
      nmap
    ];

    environment.shellAliases = {
      ll = "ls -l";
      la = "ls -la";
    };

    # HM: ca.desrt.dconf error:
    services.dbus.packages = with pkgs; [ gnome3.dconf ];

    # yuck
    programs.java = {
      enable = true;
    };


    # services.elasticsearch.enable = true;
    # services.elasticsearch.package = (pkgs.elasticsearch.override { enableUnfree = false; });

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
