{ pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      gtk = {
        enable = true;
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme=1;
          gtk-cursor-theme-name="Adwaita";
        };
      };
      home.packages = with pkgs; [
        gnome3.adwaita-icon-theme
        lxappearance
      ];
    };
  };
}
