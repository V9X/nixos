{ inputs, ... }: {
  flake.modules.nixos.pion = {
    imports = with inputs.self.modules.nixos; [
      machine
      v9x
    ];

    networking.hostName = "pion";
    system.stateVersion = "26.05";

    boot.kernelModules = [ "nct6775" ];
    services.hardware.openrgb.enable = true;

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

    home-manager.sharedModules = [
      {
        wayland.windowManager.niri.extraConfig = ''
          output "DP-1" {
            mode "3440x1440@144"
            position x=0 y=-411
            variable-refresh-rate on-demand=true
            focus-at-startup

            hot-corners {
              off
            }
          }
        '';
      }
    ];
  };

  flake.nixosConfigurations.pion = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.self.modules.nixos.pion ];
  };
}
