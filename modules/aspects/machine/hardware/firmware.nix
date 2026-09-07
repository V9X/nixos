{
  flake.modules.nixos.firmware = {
    hardware.enableRedistributableFirmware = true;
  };
}
