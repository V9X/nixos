{
  flake.modules.homeManager.rust = { pkgs, ... }: {
    home.packages = with pkgs; [
      rustc
      cargo
      clippy
      rustfmt
      rust-analyzer
      gcc
    ];
  };
}
