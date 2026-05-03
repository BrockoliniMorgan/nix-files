{ lib, ... }:
{
  options = {
    is_laptop = lib.mkEnableOption "is_laptop";
    enable_gnome = lib.mkEnableOption "Enable GNOME desktop environment";
    has_amd_gpu = lib.mkEnableOption "has_amd_gpu";
  };
}
