final: prev:
let
  changeBrightness =
    sign:
    final.writeShellScript "change_brightness" ''
      ${final.brightnessctl}/bin/brightnessctl set 5%${sign}
      BRIGHTNESSCTL_MSG=$(${final.brightnessctl}/bin/brightnessctl)
      FOURTH_COL=$(echo "$BRIGHTNESSCTL_MSG" | awk '{print $4}')
      BRIGHTNESS_BRACKETS=$(echo "$FOURTH_COL" | head -n 2 | tail -n 1)
      BRIGHTNESS_FORMATTED=$(echo "$BRIGHTNESS_BRACKETS" | sed 's/[(,)]//g')
      ${final.libnotify}/bin/notify-send -t 200 'Brightness' "$BRIGHTNESS_FORMATTED"
    '';

  changeVolume =
    sign:
    final.writeShellScript "change_volume" ''
      ${final.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ ${sign}5% 
      PACTL_MSG=$(${final.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@)
      VOLUME_SPLIT=$(echo "$PACTL_MSG" | grep -o -P "/ .*?(?>%)" - | grep -o -P "[0-9]{1,3}(?>%)" -)
      VOLUME_TOGETHER=$(echo "$VOLUME_SPLIT" | tr '\n' ' ')
      VOLUME_NO_PERCENT=($(echo "$VOLUME_TOGETHER" | sed 's/\%//g'))

      if [ ''${VOLUME_NO_PERCENT[0]} -gt 100 ] || [ ''${VOLUME_NO_PERCENT[1]} -gt 100 ]; then
        ${final.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% 
        ${final.libnotify}/bin/notify-send -t 200 'Audio' "MAX"
      else
        ${final.libnotify}/bin/notify-send -t 200 'Audio' "$VOLUME_TOGETHER"
      fi
    '';
in
{
  screenshot = final.writeShellScriptBin "screenshot" ''
    ${final.slurp}/bin/slurp | ${final.grim}/bin/grim -g - - | ${final.wl-clipboard}/bin/wl-copy
  '';
  printscreen = final.writeShellScript "printscreen" ''
    ${final.grim}/bin/grim -g - - | ${final.wl-clipboard}/bin/wl-copy
  '';
  increaseBrightness = changeBrightness "+";
  decreaseBrightness = changeBrightness "-";
  increaseVolume = changeVolume "+";
  decreaseVolume = changeVolume "-";
}
