{ pkgs, lib, config, ... }:

{
  imports = [
    ./gui.nix
  ];
  config = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome3.enable = true;

    home-manager.users.kazimazi = { pkgs, ... }: {
      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";

        QT_QPA_PLATFORM = "wayland-egl";
      };
      home.packages = with pkgs; [
        gnome3.gnome-tweaks

        qt5.qtwayland
      ];
    };
  };
}
