{ globals, ... }: {
  flake.modules.homeManager.mpv = { config, ... }: {
    programs.mpv = {
      enable = true;

      config = {
        hwdec = "auto-safe";
        save-position-on-quit = true;
        vo = "gpu-next";
      };

      bindings = {
        "${globals.keys.left}" = "seek -5";
        "${globals.keys.right}" = "seek 5";
        "${globals.keys.up}" = "add volume 5";
        "${globals.keys.down}" = "add volume -5";
      };
    };

    xdg.mimeApps.defaultApplicationPackages = [ config.programs.mpv.finalPackage ];
  };
}
