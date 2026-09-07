{
  flake.modules.nixos.helix = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.helix ];

    environment.variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };

  flake.modules.homeManager.helix = {
    programs.helix.enable = true;
  };
}
