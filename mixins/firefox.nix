{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.file = {
        ".config/tridactyl/tridactylrc".source = (pkgs.writeText "tridactyl" ''
          set editorcmd $TERMINAL -e $EDITOR
          set smoothscroll true
          set theme dark
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
      };
    };
  };
}

