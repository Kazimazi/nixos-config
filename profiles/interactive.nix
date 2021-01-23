{ config, lib, pkgs, ... }:

{
  imports = [
    ./core.nix

    ../mixins/xdg.nix
    ../mixins/gpg.nix
    ../mixins/vifm/vifm.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [
      ripgrep
      fzf # emacs tramp couldn't use fzf, how about now?
    ];

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

        cmus

        (ghc.withPackages (hp: with hp; [ haskell-language-server ]))
        cabal-install

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
