{ config, lib, pkgs, ... }:

let
  ts = import ./_common/termsettings.nix {};
  colors = ts.colors.default;
in {
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs = {
        alacritty =
        {
          enable = true;
          settings = {
            draw_bold_text_with_bright_colors = true;
            colors = {
              primary = {
                background = colors.background;
                foreground = colors.foreground;
              };
              cursor = {
                text   = colors.text;
                cursor = colors.cursor;
              };
              normal = {
                black   = colors.black;
                red     = colors.red;
                green   = colors.green;
                yellow  = colors.yellow;
                blue    = colors.blue;
                magenta = colors.magenta;
                cyan    = colors.cyan;
                white   = colors.white;
              };
              bright = {
                black   = colors.brightBlack;
                red     = colors.brightRed;
                green   = colors.brightGreen;
                yellow  = colors.brightYellow;
                blue    = colors.brightBlue;
                magenta = colors.brightMagenta;
                cyan    = colors.brightCyan;
                white   = colors.brightWhite;
              };
            };
          };
        };
      };
    };
  };
}
