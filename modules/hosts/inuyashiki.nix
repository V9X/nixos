{ inputs, ... }: {
  flake.modules.nixos.inuyashiki = { pkgs, ... }: {
    imports = [ inputs.self.modules.nixos.machine ];

    nixpkgs.hostPlatform = "aarch64-linux";
    networking.hostName = "inuyashiki";
    system.stateVersion = "26.11";

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible = {
      enable = true;
      configurationLimit = 5;
    };

    system.build.uboot = pkgs.ubootOrangePi5Plus;
  };

  flake.nixosConfigurations.inuyashiki = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.self.modules.nixos.inuyashiki ];
  };
}
