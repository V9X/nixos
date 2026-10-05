{ globals, ... }:
let
  inherit (globals) colors;
in
{
  flake.modules.nixos.desktop-niri = { pkgs, ... }: {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    hardware.i2c.enable = true;

    fonts.packages = [ pkgs.inter ];
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
        offline_mode = true;
        font_family = "Inter";

        screenshot = {
          directory = "~/Pictures/screenshots";
          save_to_file = false;
          pipe_to_command = true;
          pipe_command = ''exec ${lib.getExe' pkgs.libjxl "cjxl"} - "''${NOCTALIA_SCREENSHOT_PATH%.png}.jxl" -d 0 --quiet'';
        };

        panel = {
          transparency_mode = "glass";
          launcher_position = "auto";
          clipboard_position = "auto";
          control_center_placement = "floating";
          wallpaper_placement = "floating";
          session_placement = "floating";
          open_near_click_launcher = true;
          open_near_click_clipboard = true;
          open_near_click_control_center = true;
          open_near_click_wallpaper = true;
          open_near_click_session = true;
        };

        launcher = {
          categories = false;
          fetch_exchange_rates = false;
        };
      };

      settings.theme = {
        source = "custom";
        custom_palette = "globals";
      };

      customPalettes.globals.dark = {
        mPrimary = colors.fg;
        mOnPrimary = colors.bg;
        mSecondary = colors.br_black;
        mOnSecondary = colors.bg;
        mTertiary = colors.white;
        mOnTertiary = colors.bg;
        mError = colors.red;
        mOnError = colors.bg;
        mSurface = colors.bg;
        mOnSurface = colors.fg;
        mSurfaceVariant = colors.black;
        mOnSurfaceVariant = colors.white;
        mOutline = colors.black;
        mShadow = colors.bg;

        terminal = { };
      };

      settings.bar.default = {
        background_opacity = 0.0;
        margin_ends = 0;
        font_weight = 600;
        scale = 1.1;
        widget_spacing = 12;

        start = [
          "control-center"
          "launcher"
          "workspaces"
          "active_window"
        ];
        center = [ ];
        end = [
          "media"
          "cpu"
          "gpu"
          "ram"
          "tray"
          "notifications"
          "clipboard"
          "bluetooth"
          "network"
          "volume"
          "brightness"
          "battery"
          "clock"
        ];
      };

      settings.widget = {
        workspaces.style = "minimal";
        media.hide_when_no_media = true;
        clock.format = "{:%A %-d %b %H:%M}";

        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "none";
        };

        gpu = {
          type = "sysmon";
          stat = "gpu_usage";
          visualization = "none";
        };

        ram = {
          type = "sysmon";
          stat = "ram_pct";
          visualization = "none";
        };
      };

      settings.notification = {
        background_opacity = globals.opacity.primary;
        filter_order = [ "all" ];

        filter.all = {
          match_content = ".*";
          override_duration = 4000;
        };
      };

      settings.wallpaper = {
        transition = [ "fade" ];
        directory = "~/Pictures/wallpapers";

        automation = {
          enabled = true;
          interval_seconds = 3600;
          recursive = true;
        };
      };

      settings.audio.enable_sounds = false;

      settings.idle.behavior = {
        lock = {
          timeout = 600;
          action = "lock";
        };
        screen-off = {
          timeout = 660;
          locked_timeout = 30;
          action = "screen_off";
        };
      };

      settings.lockscreen = {
        transition_duration = 250;
        transition = [ "fade" ];
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
