{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    ../../mixins/common.nix
    ../../mixins/obs.nix
    ../../mixins/v4l2loopback.nix

    ../../profiles/sway.nix
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
      blacklistedKernelModules = [ "r8169" ]; # NOTE BROKEN - https://github.com/NixOS/nixpkgs/pull/101736
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
      { device = "/dev/disk/by-uuid/d4a433e4-04e3-48f4-b860-a72d4bec7f70";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/D7AB-49AB";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/6e548454-8b41-4aac-9a39-a9766d107621"; }
      ];

    networking = {
      hostName = "amdboi"; # Define your hostname.
      interfaces = {
        enp5s0.useDHCP = true;
      };
      hosts = {
        "127.0.0.1" = [ "localhost" ];
      };
    };

    users = {
      defaultUserShell = pkgs.fish;
      users.kazimazi = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
        ];
      };
    };

    environment.systemPackages = with pkgs; [ ];

    nixpkgs = { config.allowUnfree = true; };

    nix.maxJobs = lib.mkDefault 16;

    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware = {
      cpu.amd.updateMicrocode = true;

      opengl = {
        enable = true;
        extraPackages = with pkgs; [ rocm-opencl-icd ]; # OpenCL
      };
    };

    # for i3 
    #services.xserver = {
    #  displayManager = {
    #    sessionCommands = ''xrandr --output DisplayPort-0 --mode 1920x1080 --rate 144 --auto --output HDMI-A-0 --auto --left-of DisplayPort-0'';
    #  };
    #};

    system.stateVersion = "20.09";
  };
}
