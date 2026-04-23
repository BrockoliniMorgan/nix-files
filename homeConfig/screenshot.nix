{ pkgs, ... }:
let
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
in
{
  home.packages = [ screenshot ];
}
