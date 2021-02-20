{ config, lib, pkgs, ... }:

{
  imports = [ ];
  config = {
    # TODO check if it is redundant or not
    programs.fish.enable = true;
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs = {
        fish = {
          enable = true;
          shellInit = ''
            fish_vi_key_bindings
          '';
        };
      };

      home.file = {
        ".config/fish/fish_variables".source = (pkgs.writeText "fish" ''
          # This file contains fish universal variable definitions.
          # VERSION: 3.0
          SETUVAR __fish_initialized:3100
          SETUVAR fish_color_autosuggestion:969896
          SETUVAR fish_color_cancel:\x2dr
          SETUVAR fish_color_command:b294bb
          SETUVAR fish_color_comment:f0c674
          SETUVAR fish_color_cwd:green
          SETUVAR fish_color_cwd_root:red
          SETUVAR fish_color_end:b294bb
          SETUVAR fish_color_error:cc6666
          SETUVAR fish_color_escape:00a6b2
          SETUVAR fish_color_history_current:\x2d\x2dbold
          SETUVAR fish_color_host:normal
          SETUVAR fish_color_host_remote:yellow
          SETUVAR fish_color_match:\x2d\x2dbackground\x3dbrblue
          SETUVAR fish_color_normal:normal
          SETUVAR fish_color_operator:00a6b2
          SETUVAR fish_color_param:81a2be
          SETUVAR fish_color_quote:b5bd68
          SETUVAR fish_color_redirection:8abeb7
          SETUVAR fish_color_search_match:bryellow\x1e\x2d\x2dbackground\x3dbrblack
          SETUVAR fish_color_selection:white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3dbrblack
          SETUVAR fish_color_status:red
          SETUVAR fish_color_user:brgreen
          SETUVAR fish_color_valid_path:\x2d\x2dunderline
          SETUVAR fish_greeting:Welcome\x20to\x20fish\x2c\x20the\x20friendly\x20interactive\x20shell\x0aType\x20\x60help\x60\x20for\x20instructions\x20on\x20how\x20to\x20use\x20fish
          SETUVAR fish_pager_color_completion:normal
          SETUVAR fish_pager_color_description:B3A06D\x1eyellow
          SETUVAR fish_pager_color_prefix:white\x1e\x2d\x2dbold\x1e\x2d\x2dunderline
          SETUVAR fish_pager_color_progress:brwhite\x1e\x2d\x2dbackground\x3dcyan
        '');
      };
    };
  };
}
