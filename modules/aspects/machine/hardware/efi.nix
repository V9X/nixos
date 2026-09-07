{
  flake.modules.nixos.efi = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.efibootmgr ];

    boot.loader.efi.canTouchEfiVariables = true;
  };
}
