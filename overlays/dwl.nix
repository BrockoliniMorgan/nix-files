final: prev:
let
  generic-gaps = final.fetchpatch {
    url = "https://codeberg.org/dwl/dwl-patches/raw/commit/5d2f27a9f96bb6c6a73e217f9278ff317b7c9b42/patches/genericgaps/genericgaps-0.7.patch";
    hash = "sha256-pp/exaE8Twe1bzxRs4nYowm0BO9FYAle0icDc63hqrg=";
  };
  dim-unfocused = ./non-nix/dim-unfocused.patch;
  movestack = final.fetchpatch {
    url = "https://codeberg.org/dwl/dwl-patches/raw/commit/5d2f27a9f96bb6c6a73e217f9278ff317b7c9b42/patches/movestack/movestack-0.7.patch";
    hash = "sha256-/Ac7oQyZNVPqGiNDn0y94arN0cz98Ie1nKkQIX27bZo=";
  };
  startup_script = ./non-nix/dwl_startup_script.patch;

in
{
  dwl =
    (prev.dwl.override {
      configH = ./non-nix/dwl_config.h;
    }).overrideAttrs
      (
        {
          propagatedBuildInputs ? [ ],
          patches ? [ ],
          passthru ? { },
          postPatch ? "",
          ...
        }:
        {
          propagatedBuildInputs =
            propagatedBuildInputs
            ++ (with prev; [
              foot
              rofi
              swaybg
              waybar
            ]);
          patches = patches ++ [
            generic-gaps
            dim-unfocused
            movestack
            startup_script
          ];
          postPatch = postPatch + ''
            ;
            substituteInPlace config.h --replace "swaybg" "${prev.swaybg}/bin/swaybg"
            substituteInPlace config.h --replace "waybar" "${prev.waybar}/bin/waybar"
          '';
          passthru = passthru // {
            providedSessions = [ "dwl" ];
          };
        }
      );
}
