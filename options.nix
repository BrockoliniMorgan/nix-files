{ lib, ... }:
{
  options = {
    is_laptop = lib.mkEnableOption "is_laptop";
    has_amd_gpu = lib.mkEnableOption "has_amd_gpu";
    hyprland_display = lib.mkOption {
      type = lib.types.str;
      default = ", preferred, auto, 1";
      example = "DP-3, 2560x1440@143.91, 0x0, 1";
      description = "Default monitor config for hyprland";
    };
  };
}
