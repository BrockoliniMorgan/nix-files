{ ... }:
{
  programs = {
    bash.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "BrockoliniMorgan";
          email = "brockjamesmorgan@gmail.com";
        };
        init = {
          defaultBranch = "main";
        };
        pull.rebase = true;
      };
    };

    rofi = {
      enable = true;
      font = "Iosevka Nerd Font Mono 12";
      theme = "gruvbox-dark";
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_dark_v2";
        graph_symbol = "braille";
        proc_aggregate = true;
        proc_gradient = false;
        proc_left = true;
        proc_per_core = true;
        proc_tree = true;
        rounded_corners = false;
        swap_disk = false;
        update_ms = 100;
        vim_keys = true;
      };
    };

    home-manager.enable = true;
  };
}
