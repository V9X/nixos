{ globals, ... }: {
  flake.modules.nixos.keyboard = {
    services.keyd = {
      enable = true;

      keyboards.default = {
        ids = [
          "*"
          "-31e3:1310" # wooting
        ];

        settings = {
          global.overload_tap_timeout = 200;

          main = {
            leftalt = "overload(nav, esc)";
            capslock = "layer(alt)";
          };

          nav = {
            "${globals.keys.left}" = "left";
            "${globals.keys.down}" = "down";
            "${globals.keys.up}" = "up";
            "${globals.keys.right}" = "right";
            "capslock" = "layer(control)";
            "e" = "layer(shift)";
            "r" = "sysrq";
            "x" = "grave";
            "leftbrace" = "volumedown";
            "rightbrace" = "volumeup";
            "backslash" = "mute";
            "semicolon" = "previoussong";
            "apostrophe" = "nextsong";
            "enter" = "playpause";
            "rightshift" = "capslock";
          };
        };
      };
    };
  };
}
