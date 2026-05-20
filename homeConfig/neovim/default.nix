{ pkgs, ... }: { } // import ./full.nix { } // import ./minimal.nix { inherit pkgs; }
