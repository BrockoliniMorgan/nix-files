{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
let
  is_laptop = (osConfig.is_laptop or config.is_laptop);
  display = (osConfig.hyprland_display or config.hyprland_display);
in
{
  wayland.windowManager.mango =
    let
      backgroundPhotoDir = ./non-nix/Background.png;
    in
    {
      enable = true;
      settings =
        let
          mod = "SUPER";
        in
        {
          bind = [
            "${mod}, Return, spawn, ${pkgs.ghostty}/bin/ghostty"
            "${mod}, S, spawn, ${pkgs.rofi}/bin/rofi -show drun"
            "${mod}, V, spawn, ${pkgs.vivaldi}/bin/vivaldi"
            "${mod}, D, spawn, ${pkgs.discord}/bin/discord"
            "${mod}, U, spawn, ${pkgs.qutebrowser}/bin/qutebrowser"
            "${mod}, F, togglefloating, active"
            "${mod}, R, reload_config"
            "${mod}, F12, togglefullscreen"
            # Arrows and vim keybinds for switching windows
            "${mod}, Left, focusdir, left"
            "${mod}, Right, focusdir, right"
            "${mod}, Up, focusdir, up"
            "${mod}, Down, focusdir, down"
            "${mod}, H, focusdir, left"
            "${mod}, L, focusdir, right"
            "${mod}, K, focusdir, up"
            "${mod}, J, focusdir, down"
            # Arrows and vim keybinds for moving windows
            "${mod}+SHIFT, Left, exchange_client, left"
            "${mod}+SHIFT, Right, exchange_client, right"
            "${mod}+SHIFT, Up, exchange_client, up"
            "${mod}+SHIFT, Down, exchange_client, down"
            "${mod}+SHIFT, H, exchange_client, left"
            "${mod}+SHIFT, L, exchange_client, right"
            "${mod}+SHIFT, K, exchange_client, up"
            "${mod}+SHIFT, J, exchange_client, down"

            # Layout switching
            "${mod}+ALT, S, setlayout, scroller"
            "${mod}+ALT, T, setlayout, tile"
            "${mod}+ALT, G, setlayout, tgmix"

            "CTRL+ALT, L, spawn, ${pkgs.hyprlock}/bin/hyprlock"
            "${mod}+SHIFT, code:201, spawn, ${pkgs.ghostty}/bin/ghostty --working-directory=~/nix-files"

            "NONE, XF86AudioMute, spawn, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
            "NONE, XF86AudioMicMute, spawn, ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle"
            "NONE, XF86AudioPlay, spawn, ${pkgs.playerctl}/bin/playerctl play-pause"
            "NONE, XF86AudioNext, spawn, ${pkgs.playerctl}/bin/playerctl next"
            "NONE, XF86AudioPrev, spawn, ${pkgs.playerctl}/bin/playerctl previous"
            "NONE, XF86AudioStop, spawn, ${pkgs.playerctl}/bin/playerctl stop"
            "NONE, XF86SelectiveScreenshot, spawn, ${pkgs.screenshot}/bin/screenshot"
            "NONE, Print, spawn, ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"

            # Arrows and vim keybinds for switching workspaces incrementally
            "${mod}+CTRL, Up, viewtoleft_have_client,"
            "${mod}+CTRL, Down, viewtoright_have_client,"
            "${mod}+CTRL, K, viewtoleft_have_client"
            "${mod}+CTRL, J, viewtoright_have_client"
            "${mod}+CTRL+SHIFT, Up, tagtoleft"
            "${mod}+CTRL+SHIFT, Down, tagtoright"
            "${mod}+CTRL+SHIFT, K, tagtoleft"
            "${mod}+CTRL+SHIFT, J, tagtoright"

            "${mod}, Q, killclient"
            "${mod}+SHIFT, Q, killclient, force"
            "${mod}, M, switch_layout"
            "${mod}, A, switch_proportion_preset"
            "${mod}, 0, set_proportion, 0.4"
            "${mod}, minus, set_proportion, 0.6"
            "${mod}, equal, set_proportion, 1.0"

            "NONE, XF86MonBrightnessUp, spawn, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+ && ${pkgs.libnotify}/bin/notify-send -t 200 Brightness \"$(${pkgs.brightnessctl}/bin/brightnessctl | awk '{print $4}' | head -n 2 | tail -n 1 | sed 's/[(,)]//g')\""
            "NONE, XF86MonBrightnessDown, spawn, ${pkgs.brightnessctl}/bin/brightnessctl set 5%- && ${pkgs.libnotify}/bin/notify-send -t 200 Brightness \"$(${pkgs.brightnessctl}/bin/brightnessctl | awk '{print $4}' | head -n 2 | tail -n 1 | sed 's/[(,)]//g')\""

            # TODO: Set a limit on volume - probably requires making a shell script
            "NONE, XF86AudioLowerVolume, spawn, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% && ${pkgs.libnotify}/bin/notify-send -t 200 Audio \"$(${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | grep -o -P \"/ .*?(?>%)\" - | grep -o -P \"[0-9]{1,3}(?>%)\" - | tr '\\n' ' ')\""
            "NONE, XF86AudioRaiseVolume, spawn, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% && ${pkgs.libnotify}/bin/notify-send -t 200 Audio \"$(${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | grep -o -P \"/ .*?(?>%)\" - | grep -o -P \"[0-9]{1,3}(?>%)\" - | tr '\\n' ' ')\""
          ]
          # Workspaces 1-9 - keys 1-9
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "${mod}, code:${toString (i + 10)}, view, ${toString ws}"
                "${mod}+SHIFT, code:${toString (i + 10)}, tag, ${toString ws}"
              ]
            ) 9
          ));
          # Default layout = scroller
          tagrule = builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "id:${toString ws}, layout_name:scroller"
              ]
            ) 9
          );

          gesturebind = lib.mkIf is_laptop [
            "none,right,3,focusdir,left"
            "none,left,3,focusdir,right"
            "none,up,3,focusdir,down"
            "none,down,3,focusdir,up"
            "none,down,4,viewtoleft_have_client"
            "none,up,4,viewtoright_have_client"
          ];
          switchbind = [
            "fold, spawn, ${pkgs.hyprlock}/bin/hyprlock"
            "unfold, spawn, ${pkgs.hyprlock}/bin/hyprlock"
          ];
          exec-once = [
            # Anime girl background :)
            # "${pkgs.swaybg}/bin/swaybg -i ${backgroundPhotoDir}"
          ];
          trackpad_natural_scrolling = 1;
          disable_while_typing = 0;
          borderpx = 1;
          gappov = 4;
          gappoh = 4;
          gappiv = 4;
          gappih = 4;
          animation.duration = {
            move = 200;
            open = 200;
            tag = 200;
            close = 200;
            focus = 200;
          };
          xkb_rules.options = [
            "caps:escape"
          ];
          border_radius = 8;
          unfocused_opacity = 0.9;
          tag_animation_direction = 0;

          repeat = {
            rate = 40;
            delay = 300;
          };

          scroller_default_proportion = 0.6;

          # Background color of the root window - covered by background photo
          rootcolor = "0x323232ff";
          # Inactive window border
          bordercolor = "0x44444488";
          # Active window border
          focuscolor = "0x94949488";
          # Urgent window border (alerts)
          urgentcolor = "0xd4270888";
        };
    };
}
