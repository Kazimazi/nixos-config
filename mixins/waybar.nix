{ config, lib, pkgs, ... }:

let
  ts = import ./_common/termsettings.nix {};
  colors = ts.colors.default;
in {
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs = {
        waybar = {
          enable = true;
          #systemd.enable = true;
          settings = [
            {
              layer = "top";
              position = "top";
              height = 30;
              modules-left = [ "sway/workspaces" "sway/mode" ];
              modules-center = [ "sway/window" ];
              modules-right = [ "cpu" "clock" "tray" ];
              modules = {
                "sway/workspaces" = {
                  disable-scroll = true;
                  all-outputs = false;
                  format = "<b>{icon}</b>";
                  format-icons = {
                    "1" = "1";
                    "2" = "2";
                    "3" = "3";
                    "4" = "4";
                    "5" = "5";
                    "6" = "6";
                    "7" = "7";
                    "8" = "8";
                    "9" = "9";
                  };
                };
                "tray" = {
                  icon-size = 15;
                  spacing = 10;
                };
                "clock" = {
                  tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                  format-alt = "{:%Y-%m-%d}";
                };
                "cpu" = {
                  interval = 10;
                  format = "cpu {}%";
                  max-length = 10;
                };
              };
            }
          ];
          style = ''
            * {
                border: none;
                border-radius: 0;
                font-family: Iosevka;
                font-size: 14px;
                min-height: 0;
            }

            window#waybar {
                background-color: ${colors.background};
                color: ${colors.foreground};
            }

            #workspaces button {
                padding: 0 5px;
            }

            #workspaces button.visible {
                background-color: ${colors.brightBlack};
                color: ${colors.background};
            }

            #workspaces button.focused {
                background-color: ${colors.blue};
                color: ${colors.background};
            }

            #workspaces button.urgent {
                background-color: ${colors.brightRed};
            }

            #clock,
            #battery,
            #cpu,
            #memory,
            #temperature,
            #backlight,
            #network,
            #pulseaudio,
            #custom-media,
            #tray,
            #mode,
            #idle_inhibitor,
            #mpd {
                padding: 0 10px;
                margin: 0 4px;
                color: ${colors.foreground};
            }
          '';
        };
      };
    };
  };
}
