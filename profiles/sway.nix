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
        wf-recorder # BROKEN https://github.com/colemickens/nixpkgs-wayland/issues/242
        #inputs.nixpkgs.legacyPackages.${pkgs.system}.wf-recorder
        wl-clipboard clipman
        xwayland

        gnome3.gnome-tweaks
        gnome3.nautilus

        qt5.qtwayland
        gnome3.adwaita-icon-theme
      ];

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";

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
