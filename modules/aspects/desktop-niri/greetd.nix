{
  flake.modules.nixos.desktop-niri =
    {
      config,
      lib,
      user,
      ...
    }:
    let
      session = lib.getExe' config.programs.niri.package "niri-session";
    in
    {
      services.greetd = {
        enable = true;

        settings = {
          initial_session = {
            inherit user;
            command = session;
          };

          default_session.command = "${lib.getExe' config.services.greetd.package "agreety"} --cmd ${session}";
        };
      };

      systemd.services.greetd.serviceConfig.Restart = "always";

      security.pam.services.login.enableGnomeKeyring = lib.mkForce false;
    };
}
