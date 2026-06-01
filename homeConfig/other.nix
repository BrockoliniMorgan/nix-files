{
  pkgs,
  config,
  ...
}:
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    font = {
      name = "Iosevka Nerd Font";
      size = 10.5;
    };
    gtk4.theme = config.gtk.theme;
    colorScheme = "dark";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };
}
