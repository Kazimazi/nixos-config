{
  description = "muh nixos-config with flakes and home-manager";
  # thx colmickens cool conf :)

  # TODO use stable
  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nur.url = "github:nix-community/NUR";

    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";

    firefox.url = "github:colemickens/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";

    emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs:
  let
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };
      master = import inputs.master {
        inherit system;
        config = { allowUnfree = true; };
      };
    };
  in {
    nixosConfigurations.amdboi = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ({ pkgs, config, ... }: {
          nixpkgs.overlays = [
            overlay-unstable
            inputs.nixpkgs-wayland.overlay
            inputs.nur.overlay
            inputs.emacs.overlay
          ];
        })
        ./hosts/amdboi/configurations.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
