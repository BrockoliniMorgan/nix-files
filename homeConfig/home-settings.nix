{
  lib,
  pkgs,
  allowUnfree,
  username,
  ...
}:
{
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
        libreoffice-fresh
        neovim
        spotify
        zellij
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
    };

    shell.enableBashIntegration = true;
    shellAliases = {
      nrsf = "sudo nixos-rebuild switch --flake ~/nix-files";
      hmsf = "home-manager switch --flake ~/nix-files/";
      ngc = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d && sudo /run/current-system/bin/switch-to-configuration boot";
      ngca = "sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    };
  };
}
