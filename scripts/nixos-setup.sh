#!/usr/bin/env bash

set -euo pipefail

USERNAME=brock

# exit if run as root
if [ "$EUID" -eq 0 ]; then
  echo "Please run as yourself! Running as superuser (ie, with sudo) breaks the setup."
  exit 1
fi

cd ~
if ! [ -d "nix-files" ]; then
  echo "Nix-files repo not found! Cloning now"
  nix-shell -p gh git --command "gh auth login; gh repo clone https://github.com/BrockoliniMorgan/nix-files.git"
else
  echo "Nix-files repo already cloned. Continuing"
fi
sudo chmod +w ~/nix-files
cd ~/nix-files

HOSTNAME="$USERNAME-$1"
mkdir -p ./NixOSConfig/machine-specific-configuration/"$HOSTNAME"
mkdir -p ./homeConfig/machine-specific-home-configuration/"$HOSTNAME"

echo "{ ... }:
{

}" >./NixOSConfig/machine-specific-configuration/"$HOSTNAME"/default.nix

echo "{ ... }:
{

}" >./homeConfig/machine-specific-home-configuration/"$HOSTNAME"/default.nix
echo "Finished setting up machine-specific configs"
nix-shell --extra-experimental-features nix-command -p git --command "./scripts/regenerate-hardware-config.sh -h '$1'"

echo "Finished generating hardware config"
eval "sed -i -e '/systems = \[/a\' -e 'rec { hostName = \"\$\{userName\}-$1\"; system = \"x86_64-linux\"; userName = defaultUserName; }' ./flake.nix"
echo "Finished adding this machine to flake"
nix fmt --extra-experimental-features nix-command --extra-experimental-features flakes
echo "Formatted"
nix-shell -p git --command "git add ."
sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake ~/nix-files#"$HOSTNAME" --impure

echo "Switched"
direnv allow
