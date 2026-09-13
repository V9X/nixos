{
  flake.modules.nixos.luks = {
    boot.initrd.systemd.enable = true;

    boot.initrd.luks.devices.primary = {
      device = "/dev/disk/by-partlabel/primary";
      allowDiscards = true;
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
  };
}
