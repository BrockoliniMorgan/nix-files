{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.is_laptop {
  services = {
    # Enable GNOME for ease for others
    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    appindicator
    dock-from-dash
    just-perfection
  ];
}
