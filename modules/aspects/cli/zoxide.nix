{
  flake.modules.homeManager.zoxide = { pkgs, ... }: {
    programs.zoxide.enable = true;

    home.packages = [ pkgs.fzf ];
  };
}
