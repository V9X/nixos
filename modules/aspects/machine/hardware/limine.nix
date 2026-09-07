{
  flake.modules.nixos.limine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader = {
      limine = {
        enable = true;

        maxGenerations = 10;
        enableEditor = false;

        secureBoot = {
          enable = true;
          autoGenerateKeys = true;
        };

        extraEntries = ''
          /Windows
            protocol: efi_boot_entry
            entry: Windows Boot Manager
        '';
      };
    };
  };
}
