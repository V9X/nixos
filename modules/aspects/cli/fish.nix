{
  flake.modules.nixos.fish.programs.fish.enable = true;

  flake.modules.homeManager.fish = { pkgs, ... }: {
    programs.fish = {
      enable = true;

      plugins = [
        {
          name = "tide";
          inherit (pkgs.fishPlugins.tide) src;
        }
      ];

      functions.nixsh = {
        wraps = "nix shell";
        body = "nix shell -s IN_NIX_SHELL impure $argv -c fish";
      };

      shellAbbrs = {
        nos = "nh os switch";
        nhs = "nh home switch";

        c = "codium ./";

        ns = {
          expansion = "nixsh nixpkgs#%";
          setCursor = true;
        };

        gcm = {
          expansion = "git commit -m \"%\"";
          setCursor = true;
        };
      };

      interactiveShellInit = "set -g fish_greeting";

      shellInit = ''
        set -g fish_key_bindings fish_default_key_bindings

        set -g tide_prompt_add_newline_before true
        set -g tide_prompt_transient_enabled true
        set -g tide_prompt_color_separator_same_color white
        set -g tide_left_prompt_separator_same_color "  "
        set -g tide_left_prompt_separator_diff_color "  "
        set -g tide_left_prompt_suffix " "
        set -g tide_left_prompt_items pwd git nix_shell jobs cmd_duration newline context character
        set -g tide_right_prompt_items

        set -g tide_context_color_root magenta
        set -g tide_context_color_ssh yellow
        set -g tide_context_hostname_parts 1

        set -g tide_pwd_icon_unwritable 
        set -g tide_pwd_color_dirs blue
        set -g tide_pwd_color_anchors brblue
        set -g tide_pwd_color_truncated_dirs brblack
        set -g tide_pwd_markers .git

        set -g tide_git_icon 
        set -g tide_git_truncation_length 20
        set -g tide_git_color_branch green
        set -g tide_git_color_staged brblack
        set -g tide_git_color_dirty brblack
        set -g tide_git_color_untracked yellow
        set -g tide_git_color_stash yellow
        set -g tide_git_color_upstream yellow
        set -g tide_git_color_operation red
        set -g tide_git_color_conflicted red

        set -g tide_nix_shell_icon 
        set -g tide_nix_shell_color cyan

        set -g tide_jobs_icon 
        set -g tide_jobs_color green
        set -g tide_jobs_number_threshold 2

        set -g tide_cmd_duration_icon 
        set -g tide_cmd_duration_color white
        set -g tide_cmd_duration_decimals 0
        set -g tide_cmd_duration_threshold 3000

        set -g tide_character_icon ❯
        set -g tide_character_color green
        set -g tide_character_color_failure red
      '';
    };
  };
}
