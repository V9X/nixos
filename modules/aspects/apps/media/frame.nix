{
  flake.modules.homeManager.frame = { lib, pkgs, ... }: {
    home.packages = [
      (pkgs.symlinkJoin {
        name = "frame";
        paths = [ pkgs.frame-media-converter ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/frame --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [ pkgs.dbus ]
        }";
      })
    ];
  };
}
