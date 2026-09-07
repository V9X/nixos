{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      enableTransience = true;
    };
  };
}
