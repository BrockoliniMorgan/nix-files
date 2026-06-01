{
  lib,
  pkgs,
  allowUnfree,
  username,
  config,
  ...
}:
let
  inherit (config) terminal;
in
{
  programs.${terminal}.enable = true;
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "25.11";

    packages =
      with pkgs;
      [
        discord
        evince # Gnome document viewer
        kicad-unstable-small
        gnome-calculator
        neovim
        spotify
      ]
      ++ (with unstable; [
        bambu-studio
      ]);

    file = {
      # To allow nix-shell -p to access unfree packages without having to mess with environment variables
      ".config/nixpkgs/config.nix".text = ''
        {
          allowUnfree = ${lib.boolToString allowUnfree};
        }
      '';
      # Use this for special networks authentication - ones that have security
      "ca-bundle.crt".source = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };

    shell.enableBashIntegration = true;
    shellAliases = {
      nrsf = "sudo nixos-rebuild switch --flake ~/nix-files";
      hmsf = "home-manager switch --flake ~/nix-files/ -b bak";
      ngc = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d && sudo /run/current-system/bin/switch-to-configuration boot";
      ngca = "sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      nfu = "nix flake update";
      dr = "direnv reload";
    };
  };
}
