{ config, lib, pkgs, ... }:

let
  ts = import ./_common/termsettings.nix {};
  _colors = ts.colors.default;
  #swayfont = "Iosevka Bold 9";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  statusCommand = "${pkgs.waybar}/bin/waybar";
in {
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      wayland.windowManager.sway = {
        enable = true;
        systemdIntegration = true;
        wrapperFeatures.gtk = true;
        config = rec {
          modifier = "Mod4";
          inherit terminal;
          #fonts = [ swayfont ];
          menu = "bemenu-run"; # TODO clarify
          focus = {
            followMouse = "no";
            mouseWarping = false;
          };
          window.border = 4;
          startup = [
            { always = true; command = "${pkgs.systemd}/bin/systemd-notify --ready || true"; }
            { always = true; command = "${pkgs.mako}/bin/mako"; }
          ];
          input = {
            "type:keyboard" = { xkb_options = "caps:swapescape"; };
            "type:mouse" = { accel_profile = "flat"; pointer_accel = "0"; };
          };
          keybindings = lib.mkOptionDefault {
            "${modifier}+d" = "exec ${pkgs.bemenu}/bin/dmenu_path | ${pkgs.bemenu}/bin/bemenu-run -i -n -m all | ${pkgs.bemenu}/bin/xargs swaymsg exec --";
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "Print"       = ''exec ${pkgs.grim}/bin/grim'';
            "Shift+Print" = ''exec ${pkgs.grim}/bin/grim  -g \"$(slurp)\"'';
          };
          output = {
            "*" = { bg = "~/.background-image fill"; }; # FIXME
            HDMI-A-1 = { resolution = "1920x1080@60Hz"; position = "0,0"; };
            DP-1 = { resolution = "1920x1080@144Hz"; position = "1920,0"; adaptive_sync = "off"; };
          };
          bars = [{ command = statusCommand; }];
          colors = {
            background = _colors.background;
            focused = {
              background  = _colors.blue;
              border      = _colors.blue;
              childBorder = _colors.blue;
              indicator   = _colors.magenta;
              text        = _colors.text;
            };
            focusedInactive = {
              background  = _colors.brightBlack;
              border      = _colors.brightBlack;
              childBorder = _colors.brightBlack;
              indicator   = _colors.magenta;
              text        = _colors.foreground;
            };
            placeholder = {
              background  = _colors.white;
              border      = _colors.white;
              childBorder = _colors.white;
              indicator   = _colors.brightMagenta;
              text        = _colors.text;
            };
            unfocused = {
              background  = _colors.white;
              border      = _colors.white;
              childBorder = _colors.white;
              indicator   = "#292d2e";
              text        = _colors.foreground;
            };
            urgent = {
              background  = _colors.brightRed;
              border      = _colors.brightRed;
              childBorder = _colors.brightRed;
              indicator   = _colors.white;
              text        = _colors.text;
            };
          };
        };
        extraConfig = ''
          for_window [shell="xwayland"] title_format "%title [XWayland]"
        '';
      };
    };
  };
}
