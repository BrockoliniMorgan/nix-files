{ pkgs, ... }:
{
  environment = {
    systemPackages = (
      with pkgs;
      [
        waybar
        bluez # Bluetooth
        brightnessctl
        btop
        curl
        dunst # Notifications
        ethtool
        git
        gh
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
    hyprland.enable = true;
    ssh.startAgent = true;
    mango.enable = true;
  };
}
