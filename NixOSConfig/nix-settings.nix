{ username, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings = {
      auto-optimise-store = true;
      download-buffer-size = 134217728;
      # To be able to run "nix command" instead of "nix-command" and to use flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      warn-dirty = false;

      # Setup trusted substituters for perseus repo and hyprland
      trusted-substituters = [
        "https://roar-qutrc.cachix.org"
        "https://ros.cachix.org"
        "https://hyprland.cachix.org"
      ];
      extra-trusted-public-keys = [
        "roar-qutrc.cachix.org-1:ZKgHZSSHH2hOAN7+83gv1gkraXze5LSEzdocPAEBNnA="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      # REMOVE THIS - Useful for cross-compiling, checking packages build on aarch64-darwin
      trusted-users = [ username ];
      # Keep direnv stuff
      keep-derivations = true;
      keep-outputs = true;

      cores = 12;
    };
  };
}
