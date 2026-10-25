{
  flake.modules.homeManager.xdg = {
    xdg.mimeApps.enable = true;

    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      desktop = null;
      templates = null;
      publicShare = null;
    };
  };
}
