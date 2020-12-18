{ config, lib, pkgs, ... }:

{
  imports = [
    ./core.nix

    ../mixins/xdg.nix
  ];
  config = {
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

        ghc
        haskellPackages.haskell-language-server

        (rstudioWrapper.override { packages = with rPackages; [ car foreign readxl moments mice nortest ]; })

        ripgrep

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
