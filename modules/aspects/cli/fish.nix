{
  flake.modules.nixos.fish.programs.fish.enable = true;

  flake.modules.homeManager.fish = {
    programs.fish = {
      enable = true;

      interactiveShellInit = "set -g fish_greeting";

      shellAbbrs = {
        nos = "nh os switch";
        nhs = "nh home switch";

        c = "codium ./";

        gcm = {
          expansion = "git commit -m \"%\"";
          setCursor = true;
        };
      };
    };
  };
}
