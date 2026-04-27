{ ... }:
{
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        eval "$(direnv hook bash)"
      '';
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
      config = builtins.fromTOML ''
        [global]
        hide_env_diff = true
      '';
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "BrockoliniMorgan";
          email = "brockjamesmorgan@gmail.com";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };

    ghostty = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        font-family = "Iosevka Nerd Font";
        font-size = 10.5;
        theme = "Gruvbox Dark";
        window-inherit-working-directory = false;
        app-notifications = false;
        clipboard-read = "allow";
        clipboard-write = "allow";

      };
    };

    kitty = {
      enable = true;
      font = {
        size = 10.5;
        name = "Iosevka Nerd Font Mono";
      };
      environment.EDITOR = "nvim";
      themeFile = "gruvbox-dark";
      enableGitIntegration = true;
      shellIntegration.enableBashIntegration = true;
      settings = {
        scrollback_lines = 20000;
        clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
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
