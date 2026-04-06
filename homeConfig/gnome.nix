{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
let
  enable_gnome = (osConfig.enable_gnome or config.enable_gnome);
in
lib.mkIf enable_gnome {
  home.packages = with pkgs; [ dconf-editor ];
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell/extensions/appindicator" = {
        icon-brightness = 0.0;
        icon-contrast = 0;
        icon-opacity = 255;
        icon-saturation = 0.0;
        icon-size = 0;
      };
    };
  };
}
