{
  description = "muh nixos-config with flakes and home-manager";
  # thx colmickens cool conf :)

  # TODO use stable
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    # only needed if you use as a package set: which I do... right?
    nixpkgs-wayland.inputs.master.follows = "master";

    firefox.url = "github:colemickens/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";

    emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs:
  let
    system = "x86_64-linux";
    overlays = final: prev: {
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
            overlays
            inputs.nixpkgs-wayland.overlay
            inputs.nur.overlay
            inputs.emacs.overlay
          ];
        })
        ./hosts/amdboi/configurations.nix
      ];
      specialArgs = { inherit inputs; };
    };
    nixosConfigurations.msi = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        ({ pkgs, config, ... }: {
          nixpkgs.overlays = [
            overlays
            inputs.nur.overlay
            inputs.emacs.overlay
          ];
        })
        ./hosts/msi/configurations.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
