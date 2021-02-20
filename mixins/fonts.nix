{ config, lib, pkgs, ... }:

{
  config = {
    fonts = {
      fontDir.enable= true;
      fonts = with pkgs; [
        emacs-all-the-icons-fonts
        nerdfonts
        source-han-sans-japanese
        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk
        noto-fonts-emoji
      ];

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}

