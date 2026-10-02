{ globals, ... }: {
  flake.modules.nixos.fonts = { lib, pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.monaspace
      noto-fonts
    ];

    fonts.fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        monospace = lib.mkBefore [ globals.font.mono ];
        sansSerif = lib.mkBefore [ globals.font.sans ];
        serif = lib.mkBefore [ globals.font.serif ];
      };
    };
  };
}
