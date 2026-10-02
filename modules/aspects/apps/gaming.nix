{
  flake.modules.nixos.gaming = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override { extraEnv.MANGOHUD = true; };
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.gamescope.enable = true;
  };

  flake.modules.homeManager.gaming = { pkgs, ... }: {
    home.packages = [ (pkgs.heroic.override { extraEnv.MANGOHUD = true; }) ];

    xdg.configFile."heroic/tools/proton/GE-Proton".source = pkgs.proton-ge-bin.steamcompattool;

    programs.mangohud = {
      enable = true;
      settings = {
        fps_limit = [
          140
          0
        ];
        no_display = true;
      };
    };
  };
}
