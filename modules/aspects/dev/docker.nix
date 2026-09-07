{
  flake.modules.nixos.docker = { user, ... }: {
    virtualisation.docker.enable = true;
    users.users.${user}.extraGroups = [ "docker" ];
  };
}
