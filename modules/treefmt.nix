{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";

    programs.deadnix.enable = true;
    settings.formatter.deadnix.priority = 1;

    programs.statix = {
      enable = true;
      disabled-lints = [ "repeated_keys" ];
    };
    settings.formatter.statix.priority = 2;

    programs.nixfmt = {
      enable = true;
      strict = true;
    };
    settings.formatter.nixfmt.priority = 3;
  };
}
