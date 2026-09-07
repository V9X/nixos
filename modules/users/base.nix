{ inputs, lib, ... }:
let
  aspects =
    lib.genAttrs
      (lib.attrNames inputs.self.modules.nixos ++ lib.attrNames inputs.self.modules.homeManager)
      (name: {
        nixos = inputs.self.modules.nixos.${name} or { };
        homeManager = inputs.self.modules.homeManager.${name} or { };
      });

  chosen = with aspects; [
    claude
    discord
    vscodium
    helix
    firefox
    fish
    gaming
    git
    legacy
    mime
    mpv
    nh
    python
    qbittorrent
    rust
    starship
    swayimg
    thunar
    vlc
    wayland
    docker
  ];
in
{
  flake.modules.homeManager.user = {
    imports = map (a: a.homeManager) chosen;
  };

  flake.modules.nixos.user = {
    imports = map (a: a.nixos) chosen;
  };
}
