{ globals, ... }:
let
  inherit (globals) colors;
in
{
  flake.modules.homeManager.vscodium = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      # Nix
      nil
      nixfmt

      # Python
      ruff
      basedpyright
    ];

    programs.vscodium = {
      enable = true;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          ms-python.python
          detachhead.basedpyright
          charliermarsh.ruff
          rust-lang.rust-analyzer
          usernamehw.errorlens
          shd101wyy.markdown-preview-enhanced
        ];

        userSettings = {
          "workbench.colorTheme" = "Dark Modern";
          "workbench.colorCustomizations" = {
            "terminal.ansiBlack" = colors.black;
            "terminal.ansiRed" = colors.red;
            "terminal.ansiGreen" = colors.green;
            "terminal.ansiYellow" = colors.yellow;
            "terminal.ansiBlue" = colors.blue;
            "terminal.ansiMagenta" = colors.magenta;
            "terminal.ansiCyan" = colors.cyan;
            "terminal.ansiWhite" = colors.white;

            "terminal.ansiBrightBlack" = colors.br_black;
            "terminal.ansiBrightRed" = colors.br_red;
            "terminal.ansiBrightGreen" = colors.br_green;
            "terminal.ansiBrightYellow" = colors.br_yellow;
            "terminal.ansiBrightBlue" = colors.br_blue;
            "terminal.ansiBrightMagenta" = colors.br_magenta;
            "terminal.ansiBrightCyan" = colors.br_cyan;
            "terminal.ansiBrightWhite" = colors.br_white;
          };

          "window.openFilesInNewWindow" = "default";

          "editor.fontFamily" = "'${globals.font.mono}', monospace";
          "editor.fontLigatures" = lib.concatMapStringsSep ", " (f: "'${f}'") globals.font.mono_features;
          "terminal.integrated.fontFamily" = "'${globals.font.mono_wide}', monospace";
          "terminal.integrated.enableKittyKeyboardProtocol" = false;

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings".nil.formatting.command = [
            "nixfmt"
            "--strict"
          ];

          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
            "editor.formatOnSave" = true;
            "editor.tabSize" = 2;
          };

          "python.languageServer" = "None";
          "basedpyright.analysis.typeCheckingMode" = "standard";
          "[python]" = {
            "editor.defaultFormatter" = "charliermarsh.ruff";
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.fixAll.ruff" = "explicit";
              "source.organizeImports.ruff" = "explicit";
            };
          };
        };
      };
    };

    xdg.mimeApps.defaultApplications = lib.genAttrs [
      "text/plain"
      "application/json"
      "application/xml"
      "application/yaml"
    ] (_: "codium.desktop");
  };
}
