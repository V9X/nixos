{ globals, ... }:
let
  inherit (globals) colors;
in
{
  flake.modules.nixos.ghostty.environment.sessionVariables.TERMINAL = "ghostty";

  flake.modules.homeManager.ghostty = {
    programs.ghostty = {
      enable = true;

      clearDefaultKeybinds = true;

      settings = {
        font-family = globals.font.mono_wide;
        font-size = globals.font.size;
        font-feature = globals.font.mono_features;

        mouse-hide-while-typing = true;
        cursor-style = "bar";
        adjust-cursor-thickness = 1;
        adjust-cursor-height = -1;
        right-click-action = "copy";

        shell-integration-features = "ssh-env";
        notify-on-command-finish = "unfocused";

        window-padding-balance = true;
        window-padding-color = "extend";
        resize-overlay = "never";

        background-opacity = globals.opacity;
        background = colors.bg;
        foreground = colors.fg;
        selection-background = "cell-foreground";
        selection-foreground = "cell-background";

        palette = [
          "0=${colors.black}"
          "1=${colors.red}"
          "2=${colors.green}"
          "3=${colors.yellow}"
          "4=${colors.blue}"
          "5=${colors.magenta}"
          "6=${colors.cyan}"
          "7=${colors.white}"
          "8=${colors.br_black}"
          "9=${colors.br_red}"
          "10=${colors.br_green}"
          "11=${colors.br_yellow}"
          "12=${colors.br_blue}"
          "13=${colors.br_magenta}"
          "14=${colors.br_cyan}"
          "15=${colors.br_white}"
        ];

        keybind = [
          "ctrl+shift+c=copy_to_clipboard:mixed"
          "ctrl+shift+v=paste_from_clipboard"

          "ctrl+shift+p=toggle_command_palette"
          "ctrl+shift+h=write_screen_file:open"
        ];
      };
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };
}
