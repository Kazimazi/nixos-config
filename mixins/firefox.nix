{ config, lib, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [ libva-utils ];
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.file = {
        ".config/tridactyl/tridactylrc".source = (pkgs.writeText "tridactyl" ''
          set editorcmd $TERMINAL -e $EDITOR
          set smoothscroll true
          set theme dark
          set modeindicator false
          bind gd tabdetach
          bind gD composite tabduplicate; tabdetach
          bind ZZ !s killall firefox
        '');
      };

      programs = {
        firefox = {
          enable = true;
          package = pkgs.firefox.override { extraNativeMessagingHosts = [ pkgs.tridactyl-native ]; };
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            betterttv
            ublock-origin
            i-dont-care-about-cookies
            h264ify
            tridactyl
          ];
          profiles = {
            personal = {
              name = "Personal";
              id = 0;
              isDefault = true;
              settings = {
                #"browser.uidensity" = 1; # BUG v86 might fix hamburger menu

                "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
                "browser.search.suggest.enabled" = false;
                "browser.urlbar.placeholderName" = "DuckDuckGo";

                "browser.toolbars.bookmarks.visibility" = "newtab";
                "devtools.theme" = "dark";
                "extensions.pocket.enabled" = false;

                "privacy.donottrackheader.enabled" = true;
                "privacy.donottrackheader.value" = 1;
                "privacy.trackingprotection.cryptomining.enabled" = true; # Blocks CryptoMining
                "privacy.trackingprotection.enabled" = false; # redundant if you are already using uBlock Origin 3rd party filters
                "privacy.trackingprotection.fingerprinting.enabled" = true; # Blocks Fingerprinting
                "privacy.trackingprotection.origin_telemetry.enabled" = false;

                "extensions.webextensions.restrictedDomains" = "";

                #"gfx.webrender.all" = true;
                "media.ffmpeg.vaapi.enabled" = true;
                "media.ffvpx.enabled" = false;
                "widget.wayland-dmabuf-vaapi.enabled" = true;
              };
            };
          };
        };
      };
    };
  };
}

