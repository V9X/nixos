{
  flake.modules.nixos.removable = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.cryptsetup ];

    boot.supportedFilesystems = [ "ntfs" ];

    services.udisks2.enable = true;

    services.udisks2.settings."mount_options.conf".defaults = {
      btrfs_defaults = [
        "noatime"
        "compress=zstd:3"
      ];
    };
  };
}
