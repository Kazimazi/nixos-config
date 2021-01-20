{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./interactive.nix

    ../mixins/alacritty.nix
    ../mixins/mpv.nix
    ../mixins/fonts.nix
    ../mixins/firefox.nix
    ../mixins/gtk.nix
    ../mixins/pipewire.nix
    ../mixins/qt.nix
    ../mixins/vscode.nix
  ];
  config = {
    sound = {
      enable = true;
    };

    hardware = {
      #pulseaudio = { enable = true; }; # set in pipewire.nix
      ckb-next.enable = false;
    };

    environment.systemPackages = with pkgs; [
    ];

    home-manager.users.kazimazi = { pkgs, ... }: {
      home.sessionVariables = {
        BROWSER = "firefox";
        TERMINAL = "alacritty";
      };

      programs = {
        chromium.enable = true;
      };

      home.packages = with pkgs; [
        imv
        gnome3.eog

        gnome3.nautilus


        nyxt

        anki
        texlive.combined.scheme-full # for latex
        keepassxc
        papirus-icon-theme # fills some missing icons
        zathura

        master.discord
        my-nixpkgs.element-desktop
        skypeforlinux
        zoom-us

        filezilla
        qbittorrent

        libreoffice-fresh

        pavucontrol

        lispPackages.quicklisp
        sbcl

        jetbrains.webstorm
        blender

        octaveFull

        krita
      ];
    };
  };
}
