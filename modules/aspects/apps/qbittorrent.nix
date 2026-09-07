{
  flake.modules.homeManager.qbittorrent = { pkgs, ... }: {
    home.packages = [ pkgs.qbittorrent ];

    xdg.mimeApps.defaultApplicationPackages = [ pkgs.qbittorrent ];
  };
}
