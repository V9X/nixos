{ globals, ... }: {
  flake.modules.nixos.plymouth =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (globals) colors;
      hex = builtins.replaceStrings [ "#" ] [ "0x" ];
      px = n: toString (builtins.floor (n * config.boot.plymouth.height / 1080.0 + 0.5));
      box = w: h: ''width="${px w}" height="${px h}" viewBox="0 0 ${toString w} ${toString h}"'';

      themePackage = pkgs.runCommand "plymouth-theme" { nativeBuildInputs = [ pkgs.librsvg ]; } ''
        mkdir -p $out/share/plymouth/themes/theme
        cd $out/share/plymouth/themes/theme

        svg() { rsvg-convert -o "$1.png" - <<<"$2"; }

        rsvg-convert -w ${px 170} -h ${px 170} -o watermark.png \
          ${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg

        svg entry  '<svg ${box 300 24}><rect y="22" width="100%" height="2" fill="${colors.br_black}"/></svg>'
        svg bullet '<svg ${box 10 10}><circle cx="50%" cy="50%" r="3" fill="${colors.fg}"/></svg>'
        svg lock   '<svg ${box 1 1}/>'

        cat > theme.plymouth <<EOF
        [Plymouth Theme]
        ModuleName=two-step

        [two-step]
        ImageDir=$PWD
        BackgroundStartColor=${hex colors.bg}
        BackgroundEndColor=${hex colors.bg}

        WatermarkHorizontalAlignment=.5
        WatermarkVerticalAlignment=.42

        DialogVerticalAlignment=.58
        ProgressBarVerticalAlignment=.58
        ProgressBarWidth=${px 300}
        ProgressBarHeight=${px 7}
        ProgressBarBackgroundColor=${hex colors.br_black}
        ProgressBarForegroundColor=${hex colors.fg}

        [boot-up]
        UseProgressBar=true
        EOF
      '';
    in
    {
      options.boot.plymouth.height = lib.mkOption {
        type = lib.types.int;
        default = 1080;
      };

      config = {
        boot.plymouth = {
          enable = true;

          theme = "theme";
          themePackages = [ themePackage ];
          extraConfig = "DeviceScale=1";
        };

        systemd.services = {
          plymouth-poweroff.enable = false;
          plymouth-reboot.enable = false;
          plymouth-halt.enable = false;
        };

        boot.consoleLogLevel = 3;
        boot.kernelParams = [
          "quiet"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];
      };
    };
}
