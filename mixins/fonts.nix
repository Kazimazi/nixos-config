{ config, lib, pkgs, ... }:

{
  config = {
    fonts = {
      enableFontDir = true;
      fonts = with pkgs; [
        emacs-all-the-icons-fonts
        ( nerdfonts.override { fonts = [ "VictorMono" "MPlus" "Iosevka" ]; })
        source-han-sans-japanese

        fira-code
        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk
        noto-fonts-emoji
      ];

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
        monospace = [ "Fira Code" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}

