{
  flake.modules.nixos.network = { user, ... }: {
    networking.networkmanager = {
      enable = true;

      dns = "systemd-resolved";
    };

    services.resolved = {
      enable = true;
      settings.Resolve.DNSOverTLS = "opportunistic";
    };

    users.users.${user}.extraGroups = [ "networkmanager" ];
  };
}
