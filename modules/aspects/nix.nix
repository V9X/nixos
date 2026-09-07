{ lib, ... }: {
  flake.modules.nixos.nix = { pkgs, ... }: {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;
      max-substitution-jobs = 32;
      http-connections = 50;
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    environment.systemPackages = [ pkgs.gitMinimal ];
  };
}
