{ config, lib, pkgs, ... }:

let
  terminal = "${pkgs.alacritty}/bin/alacritty";
  statusCommand = "${pkgs.i3status}/bin/i3status";
in {
  imports = [
  ];
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      xsession.enable = true;
      xsession.windowManager.i3 = {
        enable = true;
        config = rec {
          modifier = "Mod4";
          inherit terminal;
          menu = "bemenu-run"; # TODO clarify
          focus = {
            followMouse = false;
            mouseWarping = false;
          };
          window.titlebar = false;
          window.border = 4;
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
            "${modifier}+0" = null;
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = null;
            "${modifier}+b" = "split h";
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";
          };
          modes = {
            resize = {
              h = "resize shrink width 10 px or 10 ppt";
              j = "resize grow height 10 px or 10 ppt";
              k = "resize shrink height 10 px or 10 ppt";
              l = "resize grow width 10 px or 10 ppt";
              Escape = "mode default";
            };
          };
          # FIXME stuff on the bar is missing
          #bars = [{
          #  position = "top";
          #  command = "\${pkgs.i3-gaps}/bin/i3bar -t";
          #  inherit statusCommand;
          #}];
        };
      };
    };
  };
}

