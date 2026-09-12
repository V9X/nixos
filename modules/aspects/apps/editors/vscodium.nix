{ globals, ... }: {
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
          "window.openFilesInNewWindow" = "default";

          "editor.fontFamily" = "'${globals.font.mono}', monospace";
          "editor.fontLigatures" = lib.concatMapStringsSep ", " (f: "'${f}'") globals.font.mono_features;
          "terminal.integrated.fontFamily" = "'${globals.font.mono}', monospace";
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
