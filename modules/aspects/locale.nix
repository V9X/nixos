{
  flake.modules.nixos.locale = {
    time.timeZone = "Europe/Warsaw";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings.LC_TIME = "en_GB.UTF-8";

    console.keyMap = "pl2";
    services.xserver.xkb.layout = "pl";
    environment.sessionVariables.XKB_DEFAULT_LAYOUT = "pl";
  };
}
