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
      opengl = {
        enable = true;
        extraPackages = with pkgs; [ rocm-opencl-icd ]; # OpenCL
      };
    };

    environment.systemPackages = with pkgs; [
    ];

    home-manager.users.kazimazi = { pkgs, ... }: {
      home.sessionVariables = {
        BROWSER = "chromium";
        TERMINAL = "alacritty";
      };

      programs = {
        firefox = {
          enable = true;
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
                "extensions.pocket.enabled" = false;
                "privacy.trackingprotection.cryptomining.enabled" = true; # Blocks CryptoMining
                "privacy.trackingprotection.enabled" = false; # redundant if you are already using uBlock Origin 3rd party filters
                "privacy.trackingprotection.fingerprinting.enabled" = true; # Blocks Fingerprinting
                "privacy.trackingprotection.origin_telemetry.enabled" = false;
                "gfx.webrender.enabled" = true;
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
