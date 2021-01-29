{ config, lib, pkgs, ... }:

{
  config = {
    console.useXkbConfig = true;
    # try doas
    security.doas.enable = true;
    security.sudo.enable = false;
    services = {
      openssh.enable = true;
      xserver = {
        xkbOptions = "caps:swapescape";
        layout = "us";
        dpi = 96;
      };
      upower.enable = true;
    };
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      # add binary caches for nixpkgs-wayland
      binaryCachePublicKeys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      binaryCaches = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nix-community.cachix.org"
      ];
    };

    time.timeZone = "Europe/Budapest";
  };
}
