{ globals, ... }: {
  flake.modules.nixos.keyboard = {
    services.keyd = {
      enable = true;

      keyboards.default = {
        ids = [ "*" ];

        settings = {
          global.overload_tap_timeout = 200;

          main.capslock = "overload(nav, esc)";

          nav = {
            "${globals.keys.left}" = "left";
            "${globals.keys.down}" = "down";
            "${globals.keys.up}" = "up";
            "${globals.keys.right}" = "right";
            "w" = "leftcontrol";
            "rightshift" = "capslock";
          };
        };
      };
    };
  };
}
