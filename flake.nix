{
  description = "muh nixos-config with flakes and home-manager";
  # thx colemickens cool conf :)

  # TODO use stable
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    my-nixpkgs.url = "github:Kazimazi/nixpkgs/master";
    #my-nixpkgs.url = "/home/kazimazi/dev/nix/nixpkgs";
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nixpkgs-wayland = {
      url = "github:colemickens/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.master.follows = "master";
    };

    firefox.url = "github:colemickens/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";

    emacs.url = "github:nix-community/emacs-overlay";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs:
  let
    system = "x86_64-linux";
    overlays = final: prev: {
      master = import inputs.master {
        inherit system;
        config = { allowUnfree = true; };
      };
      stable = import inputs.stable {
        inherit system;
        config = { allowUnfree = true; };
      };
      my-nixpkgs = import inputs.my-nixpkgs {
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
            inputs.neovim-nightly-overlay.overlay
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
            inputs.neovim-nightly-overlay.overlay
          ];
        })
        ./hosts/msi/configurations.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
