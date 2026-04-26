{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainbar = {
        layer = "top";
        position = "bottom";
        height = 22;
        output = [
          "*"
        ];
        modules-left = [
          "ext/workspaces"
          "hyprland/submap"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "disk"
          "memory"
          "battery"
          "cpu"
          "tray"
        ];
        disk = {
          format = "  {used}/{total} ({percentage_used}%)";
        };
        memory = {
          format = "  {percentage}%";
        };
        battery = {
          format = "  {capacity}%";
          states = {
            warning = 30;
            critical = 15;
          };
          events = {
            on-discharging-warning = "notify-send -u normal 'BATTERY LOW' 'Find your charger'";
            on-discharging-critical = "notify-send -u critical 'BATTERY CRITICAL' 'Plug in your battery now!'";
          };
        };
        cpu = {
          format = "  {usage}%";
        };
      };
    };
    style = ./non-nix/style.css;
    systemd = {
      enable = true;
      enableDebug = true;
      target = "hyprland-session.target";
    };
  };
}
