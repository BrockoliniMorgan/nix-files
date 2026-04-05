{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
lib.mkIf (osConfig.is_laptop or config.is_laptop) {
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
