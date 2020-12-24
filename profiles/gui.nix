{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./interactive.nix

    ../mixins/alacritty.nix
    ../mixins/mpv.nix
    ../mixins/fonts.nix
    ../mixins/gtk.nix
    ../mixins/qt.nix
    ../mixins/vscode.nix
  ];
  config = {
    sound = {
      enable = true;
    };

    hardware = {
      pulseaudio = { enable = true; };
      ckb-next.enable = true;
    };

    environment.systemPackages = with pkgs; [
    ];

    home-manager.users.kazimazi = { pkgs, ... }: {
      home.sessionVariables = {
        BROWSER = "firefox";
        TERMINAL = "alacritty";
      };
      home.file = {
        ".config/tridactyl/tridactylrc".source = (pkgs.writeText "tridactyl" ''
          set editorcmd $TERMINAL -e $EDITOR
          set smoothscroll true
        '');
      };

      programs = {
        firefox = {
          enable = true;
          package = pkgs.master.firefox.override { extraNativeMessagingHosts = [ pkgs.tridactyl-native ]; };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            tridactyl
          ];
          profiles = {
            personal = {
              name = "Personal";
              id = 0;
              isDefault = true;
              settings = {
                #"browser.uidensity" = 1;
                "devtools.theme" = "dark";
                "browser.toolbars.bookmarks.visibility" = "newtab";
                "extensions.pocket.enabled" = false;
                "privacy.trackingprotection.cryptomining.enabled" = true; # Blocks CryptoMining
                "privacy.trackingprotection.enabled" = false; # redundant if you are already using uBlock Origin 3rd party filters
                "privacy.trackingprotection.fingerprinting.enabled" = true; # Blocks Fingerprinting
                "privacy.trackingprotection.origin_telemetry.enabled" = false;
              };
            };
          };
        };
        chromium.enable = true;
      };

      home.packages = with pkgs; [
        imv
        gnome3.eog

        nyxt

        anki
        texlive.combined.scheme-full # for latex
        keepassxc
        papirus-icon-theme # fills some missing icons
        zathura

        master.discord
        element-desktop
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
