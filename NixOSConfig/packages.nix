{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config) enable_gnome;
in
{
  environment = {
    systemPackages = (
      with pkgs;
      [
        bluez # Bluetooth
        brightnessctl
        btop
        curl
        dunst # Notifications
        ethtool
        file
        home-manager
        libnotify # Notify-send
        lm_sensors
        neovim
        pavucontrol # Audio control
        sysstat
        usbutils
        vivaldi
        wget
        wirelesstools
        yazi # CLI file browser
      ]
    );
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  programs = {
    steam.enable = true;
    ssh.startAgent = true;
  }
  // lib.mkIf (!enable_gnome) {
    hyprland.enable = true;
    mango.enable = true;
  };
}
