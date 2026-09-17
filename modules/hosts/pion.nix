{ inputs, ... }: {
  flake.modules.nixos.pion = {
    imports = with inputs.self.modules.nixos; [
      machine
      v9x
    ];

    networking.hostName = "pion";
    system.stateVersion = "26.05";

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
        device = "/dev/disk/by-partlabel/boot";
        fsType = "vfat";
        options = [ "umask=0077" ];
      };
    };
  };

  flake.nixosConfigurations.pion = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.self.modules.nixos.pion ];
  };
}
