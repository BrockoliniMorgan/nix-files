final: prev: {
  screenshot = prev.writeShellScriptBin "screenshot" ''
    ${prev.slurp}/bin/slurp | ${prev.grim}/bin/grim -g - - | ${prev.wl-clipboard}/bin/wl-copy
  '';
}
