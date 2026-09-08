{ globals, lib, ... }:
let
  inherit (globals) colors;
  hex = lib.removePrefix "#";
in
{
  flake.modules.nixos.foot.environment.sessionVariables.TERMINAL = "foot";

  flake.modules.homeManager.foot = {
    programs.foot = {
      enable = true;

      settings.main.font = "${globals.font.mono}:size=${toString globals.font.size}";
      settings.scrollback.lines = 10000;
      settings.mouse.hide-when-typing = true;
      settings.bell.urgent = true;

      settings.cursor = {
        style = "beam";
        blink = true;
        beam-thickness = 1;
        blink-rate = 800;
      };

      settings.colors-dark = {
        blur = true;
        alpha = globals.opacity;

        background = hex colors.bg;
        foreground = hex colors.fg;

        regular0 = hex colors.black;
        regular1 = hex colors.red;
        regular2 = hex colors.green;
        regular3 = hex colors.yellow;
        regular4 = hex colors.blue;
        regular5 = hex colors.magenta;
        regular6 = hex colors.cyan;
        regular7 = hex colors.white;

        bright0 = hex colors.br_black;
        bright1 = hex colors.br_red;
        bright2 = hex colors.br_green;
        bright3 = hex colors.br_yellow;
        bright4 = hex colors.br_blue;
        bright5 = hex colors.br_magenta;
        bright6 = hex colors.br_cyan;
        bright7 = hex colors.br_white;
      };
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "foot.desktop" ];
    };
  };
}
