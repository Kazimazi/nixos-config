{ config, lib, pkgs, modulesPath, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvon" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    ../../mixins/common.nix

    ../../profiles/i3.nix
    ../../profiles/gaming.nix
  ];

  config = {
    boot = {
      initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
      blacklistedKernelModules = [ ];
      extraModulePackages = [ ];
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/737c7f11-901a-4039-80dd-de2573b398bc";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/7DD7-E56F";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/4bd8a4c7-30b0-43e6-acde-d8fc2244dc0e"; }
      ];

    fileSystems."/data" = { # HDD
      device = "/dev/disk/by-uuid/e3d8fea2-55e3-4bda-9cd2-e2e00d162e70";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    networking = {
      hostName = "msi"; # Define your hostname.
      networkmanager.enable = true;
      interfaces = {
      enp3s0.useDHCP = true;
      wlp2s0.useDHCP = true;
      };
      hosts = {
        "127.0.0.1" = [ "localhost" ];
      };
    };

    users = {
      defaultUserShell = pkgs.fish;
      users.kazimazi = {
        isNormalUser = true;
        home = "/home/kazimazi";
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
        ];
      };
    };

    environment.systemPackages = with pkgs; [ nvidia-offload ];

    nixpkgs = { config.allowUnfree = true; };

    nix.maxJobs = lib.mkDefault 8;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

    hardware.cpu.intel.updateMicrocode = true;

    hardware.nvidia.prime.offload.enable = true;
    hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
    hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";

    services.xserver.videoDrivers = [ "nvidia" ];
    services.xserver.libinput.enable = true;

    hardware = {
      opengl = {
        enable = true;
        extraPackages = with pkgs; [ vaapiIntel vaapiVdpau libvdpau-va-gl ];
      };
    };

    system.stateVersion = "20.09";
  };
}
