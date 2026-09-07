{ globals, ... }: {
  flake.modules.nixos.fonts = { lib, pkgs, ... }: {
    fonts.packages = [ pkgs.nerd-fonts.monaspace ];
    fonts.fontconfig.defaultFonts.monospace = lib.mkBefore [ globals.font.mono ];
  };
}
