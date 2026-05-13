final: prev:
let
  generic-gaps = final.fetchpatch {
    url = "https://codeberg.org/dwl/dwl-patches/raw/commit/5d2f27a9f96bb6c6a73e217f9278ff317b7c9b42/patches/genericgaps/genericgaps-0.7.patch";
    hash = "sha256-pp/exaE8Twe1bzxRs4nYowm0BO9FYAle0icDc63hqrg=";
  };
  dim-unfocused = final.fetchpatch {
    url = "https://codeberg.org/dwl/dwl-patches/raw/commit/5d2f27a9f96bb6c6a73e217f9278ff317b7c9b42/patches/dim-unfocused/dim-unfocused-20240903.patch";
    hash = "sha256-DaJ8otePMj1CQ4PG4M1VfJ0DjZNHaQtO0HUoWtm0tIE=";
  };
  movestack = final.fetchpatch {
    url = "https://codeberg.org/dwl/dwl-patches/raw/commit/5d2f27a9f96bb6c6a73e217f9278ff317b7c9b42/patches/movestack/movestack-0.7.patch";
    hash = "sha256-/Ac7oQyZNVPqGiNDn0y94arN0cz98Ie1nKkQIX27bZo=";
  };

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
          ...
        }:
        {
          propagatedBuildInputs =
            propagatedBuildInputs
            ++ (with prev; [
              foot
              rofi
            ]);
          patches = patches ++ [
            generic-gaps
            dim-unfocused
            movestack
          ];
          passthru = passthru // {
            providedSessions = [ "dwl" ];
          };
        }
      );
}
