{ inputs, pkgs, ... }:
{
  imports = [
    ./hyprland-ecosystem.nix
    ./waybar.nix
    ./other.nix
    ./home-settings.nix
    ./programs.nix
    ./screenshot.nix
    ./qutebrowser.nix
    inputs.nvf.homeManagerModules.default
    {
      programs.nvf = {
        enable = true;
        defaultEditor = true;
        settings.vim = import ./neovim.nix { inherit pkgs; };
      };
    }
    ./machine-specific-home-configuration
  ];
}
