{ pkgs, ... }:

{
  config = {
    home-manager.users.kazimazi = { pkgs, ... }: {
      programs.gpg.enable = true;
    };
  };
}
