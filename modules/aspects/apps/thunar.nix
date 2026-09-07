let
  plugins =
    pkgs: with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
in
{
  flake.modules.nixos.thunar = { pkgs, ... }: {
    programs.thunar = {
      enable = true;
      plugins = plugins pkgs;
    };

    services.tumbler.enable = true;
    services.gvfs.enable = true;
  };

  flake.modules.homeManager.thunar =
    { lib, pkgs, ... }:
    let
      #TODO: coś z tym zrobić
      terminal = lib.getExe pkgs.kdePackages.konsole;

      openTerminal = pkgs.writeShellScript "thunar-open-terminal" ''
        cd "$1" || exit 1
        exec ${terminal}
      '';
    in
    {
      home.packages = with pkgs; [
        (thunar.override { thunarPlugins = plugins pkgs; })
        xfconf
        engrampa
        p7zip
        unrar
        unar
      ];

      xdg.mimeApps.defaultApplicationPackages = [ pkgs.engrampa ];

      xfconf.settings.thunar = {
        "misc-image-preview-mode" = "THUNAR_IMAGE_PREVIEW_MODE_EMBEDDED";
        "misc-transfer-use-partial" = "THUNAR_USE_PARTIAL_MODE_REMOTE";
        "misc-date-style" = "THUNAR_DATE_STYLE_YYYYMMDD";
        "misc-directory-specific-settings" = true;
        "misc-symbolic-icons-in-sidepane" = true;
        "misc-symbolic-icons-in-toolbar" = true;
        "misc-full-path-in-tab-title" = true;
        "misc-small-toolbar-icons" = false;
        "misc-expandable-folders" = true;
        "misc-case-sensitive" = true;

        "last-toolbar-items" =
          "menu:1,back:1,forward:1,new-tab:0,toggle-split-view:1,location-bar:1,search:1";
        "last-location-bar" = "ThunarLocationButtons";
        "last-menubar-visible" = false;
      };

      xdg.configFile."Thunar/uca.xml" = {
        force = true;

        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
            <action>
              <icon>utilities-terminal</icon>
              <name>open terminal</name>
              <unique-id>open-terminal</unique-id>
              <command>${openTerminal} %f</command>
              <patterns>*</patterns>
              <startup-notify/>
              <directories/>
            </action>
          </actions>
        '';
      };

      xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
    };
}
