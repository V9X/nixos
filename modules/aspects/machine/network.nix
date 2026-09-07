{
  flake.modules.nixos.network = { user, ... }: {
    networking.networkmanager = {
      enable = true;

      wifi.backend = "iwd";
      dns = "systemd-resolved";
    };

    services.resolved = {
      enable = true;
      settings.Resolve.DNSOverTLS = "opportunistic";
    };

    users.users.${user}.extraGroups = [ "networkmanager" ];
  };
}
