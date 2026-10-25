{ inputs, ... }: {
  flake.modules.nixos.reigen = {
    imports = with inputs.self.modules.nixos; [
      machine
      v9x
    ];

    networking.hostName = "reigen";
    boot.plymouth.height = 1800;
    system.stateVersion = "26.05";

    services.asusd.enable = true;

    networking.networkmanager.wifi.powersave = false;
    boot.kernelParams = [ "cfg80211.ieee80211_regdom=PL" ];
    services.logind.settings.Login.HandlePowerKey = "suspend";

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
          output "eDP-1" {
            mode "2880x1800"
            scale 1.75
            position x=0 y=0
            variable-refresh-rate on-demand=true
            focus-at-startup

            hot-corners {
              off
            }
          }

          switch-events {
            lid-close { spawn "niri" "msg" "output" "eDP-1" "off"; }
            lid-open { spawn "niri" "msg" "output" "eDP-1" "on"; }
          }
        '';
      }
    ];
  };

  flake.nixosConfigurations.reigen = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.self.modules.nixos.reigen ];
  };
}
