{ config, lib, pkgs, ... }:

{
  imports = [
    ./core.nix

    ../mixins/xdg.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [ ripgrep ];

    # HM: ca.desrt.dconf error:
    services.dbus.packages = with pkgs; [ gnome3.dconf ];

    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.fzf.enable = true;
      home.packages = with pkgs; [
        amfora

        glxinfo
        htop

        neofetch
        pciutils

        vifm

        cmus

        # NOTE couldn't `cabal install` some stuff without these haskell packages
        (ghc.withPackages (hp: with hp; [ zlib haskell-language-server ]))
        cabal-install

        (rstudioWrapper.override { packages = with rPackages; [ car foreign readxl moments mice nortest ]; })

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
