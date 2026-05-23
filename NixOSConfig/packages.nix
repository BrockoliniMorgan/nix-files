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
        # keep-sorted start
        bluez # Bluetooth
        brightnessctl
        btop
        curl
        dunst # Notification daemon
        file
        home-manager
        libnotify # Notify-send
        neovim
        pavucontrol # Audio control
        screenshot
        vivaldi
        wget
        yazi # CLI file browser
        # keep-sorted end
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
    dwl.enable = true;
  };
}
