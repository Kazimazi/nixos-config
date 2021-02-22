{ pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.tmux = {
        enable = true;
        historyLimit = 100000;
        escapeTime = 0;
        keyMode = "vi";
        newSession = true;
        sensibleOnTop = true;
        extraConfig = ''
          set-option -g default-terminal "screen-256color"
          set-option -sa terminal-overrides ',alacritty:RGB'
        '';
      };
    };
  };
}
