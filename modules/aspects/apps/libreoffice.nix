{
  flake.modules.homeManager.libreoffice = { pkgs, ... }: {
    home.packages = with pkgs; [
      libreoffice
      hunspellDicts.pl_PL
      hunspellDicts.en_US
    ];

    xdg.mimeApps.defaultApplicationPackages = [ pkgs.libreoffice ];
  };
}
