{ pkgs, ... }:

{
  config = {
    services.pipewire.enable = true;

    xdg.portal.enable = true;
    xdg.portal.gtkUsePortal = true;
    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];

    # NOTE might not need this
    # https://github.com/NixOS/nixpkgs/issues/16327
    services.gnome3.at-spi2-core.enable = true;

    home-manager.users.kazimazi = { pkgs, ... }: {
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
