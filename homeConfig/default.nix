{ pkgs, inputs, ... }:
{
  imports = [
    ./hyprland-ecosystem.nix
    ./mango.nix
    ./waybar.nix
    ./other.nix
    ./home-settings.nix
    ./programs.nix
    ./qutebrowser.nix
    ./gnome.nix
    inputs.nvf.homeManagerModules.default
    inputs.mango.hmModules.mango
    {
      programs.nvf = {
        enable = true;
        defaultEditor = true;
        settings.vim = import ./neovim.nix { inherit pkgs; };
      };
    }
  ];
}
