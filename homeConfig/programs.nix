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
    home-manager.enable = true;
  };
}
