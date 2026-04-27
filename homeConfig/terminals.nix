{ ... }:
{
  programs = {
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
  };
}
