{
  flake.modules.nixos.nh = {
    programs.nh = {
      enable = true;

      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
  };

  flake.modules.homeManager.nh = { config, ... }: {
    home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nixos";
  };
}
