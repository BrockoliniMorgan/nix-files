{ ... }:
{
  imports = [
    ./other.nix
    ./nix-settings.nix
    ./services.nix
    ./packages.nix
    ./amd_gpu.nix
    ./gnome.nix
    ./persistence.nix
    ./hardware-configuration
  ];
}
