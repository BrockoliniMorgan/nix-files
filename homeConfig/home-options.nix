{ lib, ... }:
{
  options = {
    display = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "DP-3";
        description = "Monitor name as shown in wlr-randr";
      };
      height = lib.mkOption {
        type = lib.types.int;
        default = 0;
        example = 1080;
        description = "Height of monitor in pixels";
      };
      width = lib.mkOption {
        type = lib.types.int;
        default = 0;
        example = 1920;
        description = "Width of monitor in pixels";
      };
      frequency = lib.mkOption {
        type = lib.types.float;
        default = 60.0;
        example = 120.0;
        description = "Refresh rate of monitor in Hertz";
      };
    };
    secondary_display = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "DP-3";
      description = "Monitor name as shown in wlr-randr";
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      example = "foot";
      description = "Which terminal to use by default";
    };
  };
}
