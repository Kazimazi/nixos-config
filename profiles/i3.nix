{ config, lib, pkgs, ... }:

let
  #all-heads = pkgs.writeShellScriptBin "all-heads" ''
  #  xrandr --output DisplayPort-0 --mode 1920x1080 --rate 144 --auto --output HDMI-A-0 --auto --left-of DisplayPort-0
  #'';
  #primary-head = pkgs.writeShellScriptBin "primary-head" ''
  #  xrandr --output DisplayPort-0 --mode 1920x1080 --rate 144 --auto --output HDMI-A-0 --auto --left-of DisplayPort-0 --off
  #'';
in {
  imports = [
    ./gui.nix

    ../mixins/i3.nix
  ];
  config = {
    environment.systemPackages = [ ];
    services.xserver = {
      enable = true;
      desktopManager.wallpaper.mode = "fill";
      displayManager = {
        lightdm.enable = true;
        #sessionCommands = ''xrandr --output DisplayPort-0 --mode 1920x1080 --rate 144 --auto --output HDMI-A-0 --auto --left-of DisplayPort-0'';
        session = [{
          manage = "desktop";
          name = "xsession";
          start = "exec $HOME/.xsession";
        }];
      };
      # TODO how does it even work?
      #xrandrHeads = [
      #  { monitorConfig = ''Option "PreferredMode" "1920x1080_144"''; "output" = "DisplayPort-0"; primary = true; }
      #  { monitorConfig = ''Option "LeftOf" "DisplayPort-0"''; "output" = "HDMI-A-0"; }
      #];
    };
    #services.xrdp.enable = true; # testing stuff
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.packages = with pkgs; [ ];
    };
  };
}
