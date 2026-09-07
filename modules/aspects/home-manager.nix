{ inputs, ... }: {
  flake.modules.nixos.home-manager = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bf";
    };
  };
}
