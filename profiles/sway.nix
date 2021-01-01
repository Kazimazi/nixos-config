{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./gui.nix

    ../mixins/sway.nix
    ../mixins/waybar.nix
    ../mixins/mako.nix
  ];
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.packages = with pkgs; [
        swaylock
        swayidle

        grim # sceenshot tools
        slurp # region selector tool
        wf-recorder
        wl-clipboard
        xwayland

        gnome3.gnome-tweaks
        gnome3.nautilus

        qt5.qtwayland
        gnome3.adwaita-icon-theme
	# debug
        libinput
      ];

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
        # better place for it?
        # GTK_USE_PORTAL = 1; # messes up my gtk fonts, and cursor

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";

        SDL_VIDEODRIVER = "wayland";
        QT_QPA_PLATFORM = "wayland-egl";

        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
    };
  };
}
