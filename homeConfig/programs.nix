{ ... }:
{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
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
      settings.user = {
        name = "BrockoliniMorgan";
        email = "brockjamesmorgan@gmail.com";
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
