{
  flake.modules.homeManager.yazi = {
    programs.yazi = {
      enable = true;

      shellWrapperName = "y";

      settings = {
        mgr = {
          sort_by = "natural";
          sort_translit = true;
          linemode = "size";
        };

        input.cursor_blink = true;

        opener.open = [
          {
            run = "xdg-open %s1";
            desc = "Open";
            orphan = true;
          }
        ];

        opener.reveal = [
          {
            run = "xdg-open %d1";
            desc = "Reveal";
            orphan = true;
          }
        ];

        open.prepend_rules = [
          {
            mime = "folder/*";
            use = [
              "open"
              "edit"
              "reveal"
            ];
          }
        ];
      };

      theme = {
        tabs.inactive.bg = "black";

        mode = {
          normal_alt.bg = "black";
          select_alt.bg = "black";
          unset_alt.bg = "black";
        };
      };
    };
  };
}
