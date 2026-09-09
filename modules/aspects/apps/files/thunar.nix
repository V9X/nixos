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

    services.gvfs.enable = true;
  };

  flake.modules.homeManager.thunar = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      (thunar.override { thunarPlugins = plugins pkgs; })
      tumbler
      xfconf
      engrampa
      p7zip
      unrar
      unar
    ];

    dbus.packages = [ pkgs.tumbler ];

    xdg.mimeApps.defaultApplicationPackages = [ pkgs.engrampa ];
    xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";

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
            <command>${lib.getExe pkgs.xdg-terminal-exec} --dir=%f</command>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
          </action>
        </actions>
      '';
    };
  };
}
