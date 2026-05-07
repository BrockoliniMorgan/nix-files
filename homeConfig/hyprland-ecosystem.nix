{
  pkgs,
  osConfig,
  config,
  lib,
  ...
}:
let
  is_laptop = (osConfig.is_laptop or config.is_laptop);
  inherit (config) terminal;
in
{
  wayland.windowManager.hyprland =
    let
      workspaceNames = [
        "Browser" # 1
        "Terminal" # 2
        "3" # 3
        "4" # 4
        "5" # 5
        "6" # 6
        "7" # 7
        "8" # 8
        "9" # 9
        "10" # 10
        "11" # 11
        "Discord" # 12
      ];

      # Since paths are first-class citizens in nix, this is
      # automatically converted to an absolute path at runtime
      # so we don't need to specify the absolute path when
      # referencing this variable
      backgroundPhotoDir = ./non-nix/Background.png;
    in
    {
      portalPackage = pkgs.xdg-desktop-portal-gtk;
      systemd.variables = [ "--all" ];
      enable = true;
      package = null;
      settings =
        let
          mod = "SUPER";
        in
        {
          bind = [
            "${mod}, Return, exec, ${pkgs.${terminal}}/bin/${terminal}"
            "${mod}, S, exec, ${pkgs.rofi}/bin/rofi -show drun"
            "${mod}, V, exec, vivaldi"
            "${mod}, D, exec, discord"
            "${mod}, U, exec, qutebrowser"
            "${mod}, F, togglefloating, active"
            "${mod}+SHIFT, R, exec, hyprctl reload"
            "${mod}, F12, fullscreen"
            # Arrows and vim keybinds for switching windows
            "${mod}, code:113, movefocus, l"
            "${mod}, code:114, movefocus, r"
            "${mod}, code:111, movefocus, u"
            "${mod}, code:116, movefocus, d"
            "${mod}, H, movefocus, l"
            "${mod}, L, movefocus, r"
            "${mod}, K, movefocus, u"
            "${mod}, J, movefocus, d"
            # Arrows and vim keybinds for moving windows
            "${mod}+SHIFT, code:113, movewindow, l"
            "${mod}+SHIFT, code:114, movewindow, r"
            "${mod}+SHIFT, code:111, movewindow, u"
            "${mod}+SHIFT, code:116, movewindow, d"
            "${mod}+SHIFT, H, movewindow, l"
            "${mod}+SHIFT, L, movewindow, r"
            "${mod}+SHIFT, K, movewindow, u"
            "${mod}+SHIFT, J, movewindow, d"

            "CTRL+ALT, L, exec, hyprlock"
            ", switch:on:Lid Switch, exec, hyprlock"
            "${mod}, R, submap, Resize"
            "${mod}+SHIFT, code:201, exec, ${pkgs.${terminal}}/bin/${terminal} --working-directory=~/nix-files || ${pkgs.${terminal}}/bin/${terminal} ~/nix-files/"

            ", XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
            ", XF86AudioMicMute, exec, ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle"
            ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
            ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
            ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
            ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
            ", XF86SelectiveScreenshot, exec, ${pkgs.screenshot}/bin/screenshot"
            ", Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"
          ]
          # Workspaces 1-12 - keys 1-=
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "${mod}, code:${toString (i + 10)}, workspace, ${toString ws}"
                "${mod}+SHIFT, code:${toString (i + 10)}, movetoworkspace, ${toString ws}"
              ]
            ) 12
          ));
          binde = [
            # Arrows and vim keybinds for switching workspaces incrementally
            "${mod}+CTRL, code:113, workspace, -1"
            "${mod}+CTRL, code:114, workspace, +1"
            "${mod}+CTRL, H, workspace, -1"
            "${mod}+CTRL, L, workspace, +1"
            "${mod}+CTRL+SHIFT, code:113, movetoworkspace, -1"
            "${mod}+CTRL+SHIFT, code:114, movetoworkspace, +1"
            "${mod}+CTRL+SHIFT, H, movetoworkspace, -1"
            "${mod}+CTRL+SHIFT, L, movetoworkspace, +1"

            "${mod}, Q, killactive"
            "${mod}+SHIFT, Q, forcekillactive"

            ", XF86MonBrightnessUp, exec, ${pkgs.increaseBrightness}"
            ", XF86MonBrightnessDown, exec, ${pkgs.decreaseBrightness}"
            ", XF86AudioRaiseVolume, exec, ${pkgs.increaseVolume}"
            ", XF86AudioLowerVolume, exec, ${pkgs.decreaseVolume}"
          ];

          gesture = lib.mkIf is_laptop [
            "3, horizontal, workspace"
            "3, vertical, special, dumpWorkspace"
          ];
          decoration = {
            blur.enabled = false;
            shadow.enabled = false;
          };
          misc = {
            vfr = true;
          };
          input = {
            kb_options = [
              "caps:hyper"
            ];
            repeat_delay = 300;
            repeat_rate = 40;
            touchpad = {
              natural_scroll = true;
              middle_button_emulation = true;
              disable_while_typing = false;
            };
          };
          debug.disable_logs = false;
          # Set all unspecified monitors to their preferred resolution,
          # on the left of the others, with a scale of 1
          # The 'display' option is set in the flake.nix per-machine
          monitor = [
            ", preferred, auto-left, 1"
          ];
          animation = [
            "workspaces, 1, 0.5, default"
            "windows, 1, 0.5, default"
          ];
          windowrule = [
            # Transparent windows (0.9) when not focused, rounded corners, all window classes (REGEX)
            "opacity 1.0 0.9, rounding 10, class:(?s).*"
          ];
          workspace = [
          ]
          # The default window gaps are horrible - make them smaller, assign the default names as in workspaceNames
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "${toString ws}, gapsout:4, gapsin:4, defaultName:${builtins.elemAt workspaceNames i}"
              ]
            ) (builtins.length workspaceNames)
          ));
          exec-once = [
            # Anime girl background :)
            "${pkgs.swaybg}/bin/swaybg -i ${backgroundPhotoDir}"
            "${pkgs.waybar}/bin/waybar"
          ];
        };
      submaps = {
        Resize = {
          settings = {
            binde = [
              ", code:113, resizeactive, -20 0"
              ", code:114, resizeactive, 20 0"
              ", code:111, resizeactive, 0 -20"
              ", code:116, resizeactive, 0 20"
              ", H, resizeactive, -20 0"
              ", L, resizeactive, 20 0"
              ", K, resizeactive, 0 -20"
              ", J, resizeactive, 0 20"
              "SHIFT, code:113, resizeactive, -100 0"
              "SHIFT, code:114, resizeactive, 100 0"
              "SHIFT, code:111, resizeactive, 0 -100"
              "SHIFT, code:116, resizeactive, 0 100"
              "SHIFT, H, resizeactive, -100 0"
              "SHIFT, L, resizeactive, 100 0"
              "SHIFT, K, resizeactive, 0 -100"
              "SHIFT, J, resizeactive, 0 100"
              ", Escape, submap, reset"
            ];
          };
        };
      };
    };
  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

}
