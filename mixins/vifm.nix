{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.file = { # TODO finish it
        #".config/vifm/vifmrc".source = (pkgs.writeText "vifm" ''
        #'');
      };
      # NOTE https://github.com/NixOS/nixpkgs/pull/75004
      home.packages = with pkgs; [ vifm-full ];
    };
  };
}
