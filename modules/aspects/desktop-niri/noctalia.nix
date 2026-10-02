{
  flake.modules.nixos.desktop-niri = {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    hardware.i2c.enable = true;
  };

  flake.modules.homeManager.desktop-niri = { lib, pkgs, ... }: {
    home.packages = [ pkgs.ddcutil ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings.shell = {
        polkit_agent = true;
        launch_apps_as_systemd_services = true;
        setup_wizard_enabled = false;

        screenshot = {
          directory = "~/Pictures/screenshots";
          save_to_file = false;
          pipe_to_command = true;
          pipe_command = ''exec ${lib.getExe' pkgs.libjxl "cjxl"} - "''${NOCTALIA_SCREENSHOT_PATH%.png}.jxl" -d 0 --quiet'';
        };
      };

      settings.brightness.enable_ddcutil = true;
      settings.backdrop = {
        enabled = true;
        tint_intensity = 0.5;
      };
    };

    wayland.windowManager.niri.settings.debug.honor-xdg-activation-with-invalid-serial = { };
  };
}
