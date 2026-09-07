{ inputs, ... }: {
  flake.modules.nixos.reigen = {
    imports = with inputs.self.modules.nixos; [
      machine
      v9x
      #TODO: przenieść do base
      limine
    ];

    networking.hostName = "reigen";
    system.stateVersion = "26.05";

    boot.initrd.availableKernelModules = [
      "thunderbolt"
      "usb_storage"
    ];

    services.asusd.enable = true;

    networking.networkmanager.wifi.powersave = true;

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [ "compress=zstd:1" ];
      };
      "/home" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [
          "subvol=home"
          "compress=zstd:1"
        ];
      };
      "/nix" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [
          "subvol=nix"
          "compress=zstd:1"
          "noatime"
        ];
      };
      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
        options = [ "umask=0077" ];
      };
    };
  };

  flake.nixosConfigurations.reigen = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.self.modules.nixos.reigen ];
  };
}
