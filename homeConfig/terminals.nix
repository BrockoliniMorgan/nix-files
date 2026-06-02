{ ... }:
{
  programs = {
    ghostty = {
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

    foot = {
      settings = {
        main = {
          font = "Iosevka Nerd Font:size=10.5";
        };
        colors-dark = {
          background = "282828";
          foreground = "ebdbb2";
          regular0 = "282828";
          regular1 = "cc241d";
          regular2 = "98971a";
          regular3 = "d79921";
          regular4 = "458588";
          regular5 = "b16286";
          regular6 = "689d6a";
          regular7 = "a89984";
          bright0 = "928374";
          bright1 = "fb4934";
          bright2 = "b8bb26";
          bright3 = "fabd2f";
          bright4 = "83a598";
          bright5 = "d3869b";
          bright6 = "8ec07c";
          bright7 = "ebdbb2";
        };
        security = {
          osc52 = "enabled";
        };
      };
    };

    kitty = {
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
