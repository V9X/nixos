{
  flake.modules.nixos.luks = {
    boot.initrd.luks.devices.primary = {
      device = "/dev/disk/by-partlabel/primary";
      allowDiscards = true;
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
  };
}
