{ ... }:
{
  imports = [
    ./other.nix
    ./nix-settings.nix
    ./services.nix
    ./packages.nix
    ./amd.nix
    ./gnome.nix
    ./hardware-configuration
  ];
}
