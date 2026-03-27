{ pkgs, ... }:
{
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    displayManager.ly = {
      enable = true;
      settings = {
        bigclock = "en";
        vi_mode = true;
        vi_default_mode = "insert";
        brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
      };
    };
    # Enable the OpenSSH daemon.
    # openssh.enable = true;

    udev = {
      enable = true;
      packages = [ pkgs.platformio-core.udev ];
    };
  };
}
