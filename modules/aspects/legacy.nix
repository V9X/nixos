{
  flake.modules.nixos.legacy = _: {
    # Desktop
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.printing.enable = true;
  };
}
