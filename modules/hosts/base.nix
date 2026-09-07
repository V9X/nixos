{ inputs, ... }: {
  flake.modules.nixos.machine = {
    imports = with inputs.self.modules.nixos; [
      home-manager
      nix

      amd
      audio
      bluetooth
      btrfs
      efi
      firmware
      memory
      thunderbolt

      fonts
      locale
      network
      removable
    ];
  };
}
