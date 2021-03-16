{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../mixins/common.nix
    ../../mixins/obs.nix
    ../../mixins/v4l2loopback.nix

    ../../profiles/sway.nix
    #../../profiles/desktop-gnome.nix
    #../../profiles/i3.nix
    ../../profiles/gaming.nix
  ];

  config = {
    boot = {
      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [
        "kvm-amd"
      ];
      blacklistedKernelModules = [ "r8169" ];
      extraModulePackages = [
        config.boot.kernelPackages.r8168
      ];
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/53ca0d4e-5b69-4a0b-bcae-9155ae745d31";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/A387-04B7";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/42d8d88e-6aa8-4205-afe1-904ac467f6d4"; }
      ];

    networking = {
      hostName = "amdboi";
      useDHCP = false;
      interfaces.enp5s0.useDHCP = true;
      hosts = {
        "127.0.0.1" = [ "localhost" ];
      };
    };

    users = {
      #defaultUserShell = pkgs.bash;
      users.kazimazi = {
        isNormalUser = true;
        initialHashedPassword = "test";
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"

          "audio" # for pulsepipewire?
        ];
      };
    };

    environment.systemPackages = with pkgs; [ ];

    nixpkgs = { config.allowUnfree = true; };

    nix.maxJobs = lib.mkDefault 16;

    services.xserver.videoDrivers = [ "amdgpu" ];
    services.fstrim.enable = true;

    hardware = {
      cpu.amd.updateMicrocode = true;

      opengl = {
        enable = true;
        extraPackages = with pkgs; [ ];
      };
    };

    system.stateVersion = "21.05";
  };
}
