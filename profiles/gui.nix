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
    # ../mixins/vscode.nix # fuck vscode >:(
    ../mixins/wireshark.nix
  ];
  config = {
    sound = {
      enable = true;
    };

    hardware = {
      # pulseaudio.enable = true; # set in pipewire.nix
      ckb-next.enable = false; # used to have an error with systemd, TODO try again
    };

    environment.systemPackages = with pkgs; [
    ];

    home-manager.users.kazimazi = { pkgs, ... }: {
      home.sessionVariables = {
        BROWSER = "firefox";
        TERMINAL = "alacritty";
      };

      programs = {
        chromium = {
          enable = true;
          package = pkgs.chromium;
        };
        zathura = {
          enable = true;
          # how do I enable plugins explicitly?
          package = with pkgs; ( zathura.override { useMupdf = false; } ); # use poppler instead of mupdf
          extraConfig = ''
            set selection-clipboard clipboard
          '';
        };
      };

      home.packages = with pkgs; [
        imv
        gnome3.eog
        okular
        evince

        scenebuilder.scenebuilder

        gnome3.nautilus

        anki
        texlive.combined.scheme-full # for latex
        keepassxc
        papirus-icon-theme # fills some missing icons

        discord
        element-desktop
        # skypeforlinux
        # zoom-us

        # filezilla
        qbittorrent

        libreoffice-fresh

        pavucontrol

        lispPackages.quicklisp
        sbcl

        octaveFull

        krita
      ];
    };
  };
}
