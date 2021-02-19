{ pkgs, ... }:

{
  config = {
    xdg.portal = {
      enable = true;
      gtkUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };

    # NOTE might not need this
    # https://github.com/NixOS/nixpkgs/issues/16327
    services.gnome3.at-spi2-core.enable = true;

    home-manager.users.kazimazi = { pkgs, ... }: {
      xdg.mimeApps =
      let
        web-browser = "firefox.desktop";
      in {
        enable = true;
        defaultApplications = {
          "text/html" = web-browser;
          "x-scheme-handler/http" = web-browser;
          "x-scheme-handler/https" = web-browser;
          "x-scheme-handler/about" = web-browser;
          "x-scheme-handler/unknown" = web-browser;
          "x-scheme-handler/mailto" = web-browser;
          "application/pdf" = "org.pwmt.zathura-pdf-poppler.desktop";
          "image/png"  = "imv.desktop";
          "image/jpg" = "imv.desktop";
          "image/jpeg" = "imv.desktop";
          "video/*" = "mpv.desktop";
        };
        associations.added = {
        };
        associations.removed = {
        };
      };

      xdg.userDirs = {
        enable = true;
        desktop = "\$HOME/desktop";
        documents = "\$HOME/documents";
        download = "\$HOME/downloads";
        music = "\$HOME/documents/music";
        pictures = "\$HOME/documents/pictures";
        publicShare = "\$HOME/documents/public";
        templates = "\$HOME/documents/templates";
        videos = "\$HOME/documents/videos";
      };
    };
  };
}
