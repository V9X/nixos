{
  flake.modules.homeManager.mission-center = { pkgs, ... }: {
    home.packages = [ pkgs.mission-center ];
  };
}
