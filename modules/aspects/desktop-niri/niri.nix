{ globals, ... }:
let
  inherit (globals) keys;
  inherit (globals) colors;
in
{
  flake.modules.nixos.desktop-niri = {
    programs.niri = {
      enable = true;
      useNautilus = false;
    };
  };

  flake.modules.homeManager.desktop-niri = { lib, pkgs, ... }: {
    home.packages = [ pkgs.wl-clipboard ];

    wayland.windowManager.niri = {
      enable = true;
      systemd.enable = false;
      portalPackage = null;

      settings.prefer-no-csd = { };

      settings.binds = lib.mapAttrs (_: lib.recursiveUpdate { _props.repeat = false; }) {
        "Mod+X".spawn-sh = lib.getExe pkgs.xdg-terminal-exec;
        "Mod+C".spawn-sh = "noctalia msg panel-toggle launcher";
        "Mod+L" = {
          _props.allow-when-locked = true;
          spawn-sh = "noctalia msg session lock";
        };
        "Mod+T".close-window = { };
        "Print".spawn-sh = "noctalia msg screenshot-region";
        "Mod+F".fullscreen-window = { };
        "Mod+G".maximize-window-to-edges = { };
        "Mod+B".toggle-column-tabbed-display = { };

        "Mod+Tab".toggle-overview = { };

        "Mod+${keys.left}" = {
          _props.repeat = true;
          focus-column-left = { };
        };
        "Mod+${keys.right}" = {
          _props.repeat = true;
          focus-column-right = { };
        };
        "Mod+${keys.down}" = {
          _props.repeat = true;
          focus-window-or-workspace-down = { };
        };
        "Mod+${keys.up}" = {
          _props.repeat = true;
          focus-window-or-workspace-up = { };
        };
        "Mod+Q" = {
          _props.repeat = true;
          focus-monitor-previous = { };
        };
        "Mod+E" = {
          _props.repeat = true;
          focus-monitor-next = { };
        };

        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;

        "Mod+Shift+${keys.left}".move-column-left = { };
        "Mod+Shift+${keys.right}".move-column-right = { };
        "Mod+Shift+${keys.down}".move-window-down-or-to-workspace-down = { };
        "Mod+Shift+${keys.up}".move-window-up-or-to-workspace-up = { };
        "Mod+Shift+Q".move-column-to-monitor-previous = { };
        "Mod+Shift+E".move-column-to-monitor-next = { };

        "Mod+Shift+1".move-column-to-workspace = 1;
        "Mod+Shift+2".move-column-to-workspace = 2;
        "Mod+Shift+3".move-column-to-workspace = 3;
        "Mod+Shift+4".move-column-to-workspace = 4;
        "Mod+Shift+5".move-column-to-workspace = 5;
        "Mod+Shift+6".move-column-to-workspace = 6;
        "Mod+Shift+7".move-column-to-workspace = 7;
        "Mod+Shift+8".move-column-to-workspace = 8;
        "Mod+Shift+9".move-column-to-workspace = 9;

        "Mod+Alt+${keys.left}".switch-preset-column-width-back = { };
        "Mod+Alt+${keys.right}".switch-preset-column-width = { };
        "Mod+Alt+${keys.down}".switch-preset-window-height-back = { };
        "Mod+Alt+${keys.up}".switch-preset-window-height = { };

        "Mod+Alt+1".set-column-width = "100%";
        "Mod+Alt+2".set-column-width = "50%";

        "Mod+Ctrl+${keys.left}".consume-or-expel-window-left = { };
        "Mod+Ctrl+${keys.right}".consume-or-expel-window-right = { };
        "Mod+Ctrl+${keys.down}".move-workspace-down = { };
        "Mod+Ctrl+${keys.up}".move-workspace-up = { };
        "Mod+Ctrl+Q".move-workspace-to-monitor-previous = { };
        "Mod+Ctrl+E".move-workspace-to-monitor-next = { };

        "Mod+Ctrl+1".move-workspace-to-index = 1;
        "Mod+Ctrl+2".move-workspace-to-index = 2;
        "Mod+Ctrl+3".move-workspace-to-index = 3;
        "Mod+Ctrl+4".move-workspace-to-index = 4;
        "Mod+Ctrl+5".move-workspace-to-index = 5;
        "Mod+Ctrl+6".move-workspace-to-index = 6;
        "Mod+Ctrl+7".move-workspace-to-index = 7;
        "Mod+Ctrl+8".move-workspace-to-index = 8;
        "Mod+Ctrl+9".move-workspace-to-index = 9;

        "Mod+WheelScrollDown".focus-column-right = { };
        "Mod+WheelScrollUp".focus-column-left = { };

        "XF86AudioRaiseVolume" = {
          _props.repeat = true;
          spawn-sh = "noctalia msg volume-up";
        };
        "XF86AudioLowerVolume" = {
          _props.repeat = true;
          spawn-sh = "noctalia msg volume-down";
        };
        "XF86AudioMute".spawn-sh = "noctalia msg volume-mute";
        "XF86AudioMicMute".spawn-sh = "noctalia msg mic-mute";

        "XF86AudioPlay".spawn-sh = "noctalia msg media toggle";
        "XF86AudioPrev".spawn-sh = "noctalia msg media previous";
        "XF86AudioNext".spawn-sh = "noctalia msg media next";

        "XF86MonBrightnessUp" = {
          _props.repeat = true;
          spawn-sh = "noctalia msg brightness-up";
        };
        "XF86MonBrightnessDown" = {
          _props.repeat = true;
          spawn-sh = "noctalia msg brightness-down";
        };
      };

      extraConfig = ''
        input {
          focus-follows-mouse max-scroll-amount="25%"
          warp-mouse-to-focus
          disable-power-key-handling

          keyboard {
            repeat-delay 300
            repeat-rate 20
          }

          mouse {
            accel-speed 0.8
            accel-profile "flat"
          }
        }

        blur {
          passes 4
          offset 3.0
        }

        layout {
          gaps 10

          focus-ring {
            off
          }

          border {
            width 2
            active-color "${colors.fg}99"
            inactive-color "${colors.fg}33"
            urgent-color "${colors.red}"
          }

          shadow {
            on
            softness 10
            spread 3
            offset x=0 y=2
            color "#000000"
          }

          insert-hint {
            color "#ffffff65"
          }

          default-column-width {
            proportion 0.5
          }
          
          preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
          }

          preset-window-heights {
            proportion 0.5
            proportion 1.0
          }
        }

        layer-rule {
          match namespace="^noctalia-backdrop$"
          place-within-backdrop true
        }

        // TODO: wywalić jak będzie się dało sensownie ogarnąć to samą noctalią
        layer-rule {
          match namespace="^noctalia-bar-"

          shadow {
            on
            softness 20
            spread 20
            offset x=0 y=-48
            draw-behind-window true
            color "#00000066"
          }

          background-effect {
            blur false
          }
        }

        layer-rule {
          match namespace="^noctalia-"

          background-effect {
            xray false
          }
        }

        window-rule {
          geometry-corner-radius 10
          clip-to-geometry true
          draw-border-with-background false 
          
          background-effect {
            blur true
          }

          popups {
            geometry-corner-radius 10

            background-effect {
              blur true
            }
          }
        }

        window-rule {
          match is-floating=true

          background-effect {
            xray false
          }
        }

        window-rule {
          match app-id="^(steam_app_[0-9]+|gamescope)$"

          open-fullscreen true
          variable-refresh-rate true
        }

        output "PNP(GWD) ARZOPA 2022110200001" {
          mode "2560x1440"
          scale 1.4
          position x=-1829 y=0

          hot-corners {
            off
          }
        }
      '';
    };
  };
}
