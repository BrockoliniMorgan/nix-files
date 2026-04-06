{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.enable_gnome {
  # Enable GNOME for ease for others
  services = {
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    dock-from-dash
    just-perfection
  ];
}
