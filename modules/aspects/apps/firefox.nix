{
  flake.modules.homeManager.firefox = { config, ... }: {
    programs.firefox.enable = true;

    xdg.mimeApps.defaultApplicationPackages = [ config.programs.firefox.finalPackage ];
    xdg.mimeApps.defaultApplications."application/pdf" = "firefox.desktop";
  };
}
