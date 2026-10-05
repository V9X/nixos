{ globals, ... }: {
  flake.modules.nixos.theme = { pkgs, ... }: {
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };

  flake.modules.homeManager.theme =
    { pkgs, ... }:
    let
      inherit (globals.opacity) primary selection;
      inherit (globals.colors) bg fg;

      colors = pkgs.writeText "colors.scss" ''
        $window:            rgba(${bg}, ${toString primary});
        $bar:               rgba(${fg}, ${toString (selection / 4)});
        $surface:           rgba(lighten(${bg}, 12%), ${toString primary});
        $selection:         rgba(${fg}, ${toString selection});
        $overlay-hover:     gtkalpha(currentColor, ${toString (selection / 2)});
        $popover:           $surface;
        $titlebar:          mix(${fg}, $window, alpha($bar) * 100%);
        $titlebar-backdrop: $titlebar;
        $background:        transparent;
        $base:              transparent;
        $base-alt:          transparent;
        $sidebar:           transparent;
        $sidebar-backdrop:  transparent;
      '';

      gtk3 = pkgs.writeText "gtk3.scss" ''
        %selected_items_primary {
          color: $text;
          background-color: $selection;
        }

        .background { background-color: $window; }

        toolbar,
        menubar,
        menubar:backdrop {
          background-color: $bar;
        }

        scrolledwindow.sidebar { padding: 0 6px; }
        .sidebar treeview.view { -GtkTreeView-vertical-separator: 8; }

        .sidebar treeview.view:selected,
        .sidebar treeview.view:hover,
        widget.view:hover {
          border-radius: $corner-radius;
        }

        .path-bar.linked:not(.vertical) > button,
        toolbar:not(.inline-toolbar):not(.osd) .path-bar.linked > button {
          margin: 0 2px;
          border-radius: $corner-radius;
        }

        menu menuitem { padding: 6px 12px; }
        menu separator { margin: 4px 6px; }

        @define-color theme_selected_bg_color #{mix(${fg}, ${bg}, alpha($selection) * 200%)};
        @define-color theme_selected_fg_color #{$text};
      '';

      gtk4 = pkgs.writeText "gtk4.scss" ''
        @define-color window_bg_color #{$window};
        @define-color dialog_bg_color #{$surface};
        @define-color headerbar_bg_color #{$bar};
        @define-color headerbar_backdrop_color #{$bar};
      '';

      colloid =
        (pkgs.colloid-gtk-theme.override {
          themeVariants = [ "grey" ];
          colorVariants = [ "dark" ];
          tweaks = [
            "black"
            "rimless"
          ];
        }).overrideAttrs
          (prev: {
            postPatch = prev.postPatch + ''
              sed -i '/apps\/xfce/d' src/sass/gtk/_apps-3.0.scss
              echo '$white: ${fg}; $black: ${bg};' >> src/sass/_color-palette-default.scss
              cat ${colors} >> src/sass/_colors.scss
              cat ${gtk3} >> src/main/gtk-3.0/gtk-Dark.scss
              cat ${gtk4} >> src/main/gtk-4.0/gtk-Dark.scss
            '';
          });

      gtkTheme = {
        name = "Colloid-Grey-Dark";
        package = colloid;
      };

      icons =
        pkgs.runCommandLocal "icon-theme"
          {
            src = pkgs.fetchFromGitHub {
              owner = "musqz";
              repo = "beautysolar-icon-theme";
              rev = "d5d040d85ad234d520f7e25a46c872e066ea6df3";
              hash = "sha256-hYB14WttoLK4edAEagSj7DneBTIEAuHGXQuLi6fBQ+o=";
            };
          }
          ''
            dir=$out/share/icons/icons
            mkdir -p "$dir"/places/{16,48}
            cd $src/BeautySolar

            cp -r mimetypes "$dir"
            cp -L --parents places/{16,48}/*{folder,directory}*.svg "$dir"
            rm "$dir"/places/*/*{home,desktop}*

            awk -i inplace '/<path d="M2[56][0-9.]* [89]C/ { tab = $0; next } tab { print tab; tab = "" } 1' "$dir"/places/48/*.svg

            grep -l 'viewBox="0 0 48 48"' "$dir"/places/48/*.svg | xargs sed -i -E \
              '/<path (opacity="0\.|d="M2[56][0-9.]* [89]C)/ s|<path |<path transform="translate(24 24) scale(1.068 1) translate(-24 -24)" |'

            sed -e 's|^Inherits=.*|Inherits=Adwaita,AdwaitaLegacy|' \
              -e 's|^Directories=.*|Directories=mimetypes/scalable,places/16,places/48|' \
              -e '/^\[places\/16]/,/^\[/ s|^MaxSize=.*|MaxSize=31|' \
              -e '/^\[places\/48]/,/^\[/ s|^MinSize=.*|MinSize=16|' \
              index.theme > "$dir/index.theme"
          '';
    in
    {
      gtk = {
        enable = true;
        colorScheme = "dark";

        font = {
          name = globals.font.sans;
          inherit (globals.font) size;
        };

        theme = gtkTheme;
        gtk4.theme = gtkTheme;

        iconTheme = {
          name = "icons";
          package = icons;
        };
      };

      home.pointerCursor = {
        enable = true;
        name = "Bibata-Modern-Ice";
        size = 24;
        package = pkgs.bibata-cursors;
        gtk.enable = true;
      };

      home.packages = with pkgs; [
        adwaita-icon-theme
        adwaita-icon-theme-legacy
      ];
    };
}
