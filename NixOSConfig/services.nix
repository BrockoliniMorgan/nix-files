{
  pkgs,
  config,
  lib,
  ...
}:
{
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    speechd.enable = lib.mkForce false;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    displayManager = {
      # sessionPackages = with pkgs; [ dwl ];
      ly = {
        enable = true;
        settings = {
          bigclock = "en";
          brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          battery_id = lib.mkIf config.is_laptop "BAT0";
        };
      };
    };
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    tailscale = {
      enable = true;
    };

    udev = {
      enable = true;
      packages = [ pkgs.platformio-core.udev ];
    };
  };
}
