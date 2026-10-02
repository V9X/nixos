{ globals, ... }: {
  flake.modules.homeManager.swayimg = { pkgs, ... }: {
    programs.swayimg = {
      enable = true;

      initLua = ''
        swayimg.imagelist.adjacent = true
        swayimg.text.visible = false

        swayimg.viewer.on_key("${globals.keys.left}", function() swayimg.viewer.open("prev") end)
        swayimg.viewer.on_key("${globals.keys.right}", function() swayimg.viewer.open("next") end)
        swayimg.viewer.on_key("Tab", function() swayimg.mode = "gallery" end)
        swayimg.viewer.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)

        swayimg.gallery.on_key("${globals.keys.left}", function() swayimg.gallery.select("left") end)
        swayimg.gallery.on_key("${globals.keys.right}", function() swayimg.gallery.select("right") end)
        swayimg.gallery.on_key("${globals.keys.up}", function() swayimg.gallery.select("up") end)
        swayimg.gallery.on_key("${globals.keys.down}", function() swayimg.gallery.select("down") end)
        swayimg.gallery.on_key("Tab", function() swayimg.mode = "viewer" end)
        swayimg.gallery.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
      '';
    };

    xdg.mimeApps.defaultApplicationPackages = [ pkgs.swayimg ];
  };
}
