{ inputs, ... }: {
  flake.modules.homeManager.v9x = {
    imports = [ inputs.self.modules.homeManager.user ];

    programs.git.settings.user = {
      name = "v9x";
      email = "59032172+V9X@users.noreply.github.com";
    };

    home.stateVersion = "26.05";
  };

  flake.modules.nixos.v9x = { pkgs, ... }: {
    imports = [ inputs.self.modules.nixos.user ];

    _module.args.user = "v9x";

    users.mutableUsers = false;

    users.users.v9x = {
      isNormalUser = true;
      shell = pkgs.fish;
      hashedPasswordFile = "/etc/secrets/password";
      extraGroups = [
        "wheel"
        "video"
      ];
    };

    home-manager.users.v9x.imports = [ inputs.self.modules.homeManager.v9x ];
  };

  flake.homeConfigurations.v9x = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };

    modules = [
      inputs.self.modules.homeManager.v9x
      {
        home.username = "v9x";
        home.homeDirectory = "/home/v9x";
      }
    ];
  };
}
