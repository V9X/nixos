{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/TMUJJM9nlKm1f2KivaFmzOrp9JvYWNOKowcNbub0c v9x@reigen"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHub0xbT3D1uRjD2Z3v8v3WGWI+we2W+FXwd4FS+DUEF v9x@pion"
    ];
  };
}
