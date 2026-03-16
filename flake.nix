{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      treefmt-nix,
      flake-utils,
      ...
    }@inputs:
    let
      defaultUserName = "brock"; # Default to username "brock" when not supplied
      allowUnfree = false; # Specify this once, then make all other references to unfree stuff reference this value
      allowUnfreePredicate = # Same as above
        pkg:
        builtins.elem (lib.getName pkg) [
          "discord" # TODO: Get rid of discord, spotify, and vivaldi
          "spotify"
          "steam"
          "steam-unwrapped"
          "vivaldi"
        ];
      inherit (nixpkgs) lib;

      # Need this to be a function so it can be architecture-independent
      mkOverlays = system: [
        # Allow accessing pkgs.unstable or pkgs.master for really new stuff
        (import ./overlays/unstable.nix (
          inputs # All of the flake inputs
          // {
            inherit # TODO: clean this up. It looks like it could be done better
              system
              allowUnfree
              allowUnfreePredicate
              ;
          }
        ))
      ];
      # All of my (current) systems
      systems = [
        rec {
          hostName = "${userName}-vivobook";
          system = "x86_64-linux";
          userName = defaultUserName;
        }
        rec {
          hostName = "${userName}-thinkpad";
          system = "x86_64-linux";
          userName = defaultUserName;
        }
        rec {
          hostName = "${userName}-desktop";
          system = "x86_64-linux";
          userName = defaultUserName;
        }
      ];
      createSystem = # Create a NixOS system
        {
          hostName,
          system,
          userName ? defaultUserName,
          ...
        }:
        {
          ${hostName} = lib.nixosSystem {
            inherit system;
            modules = [
              (
                { allowUnfree, ... }: # Nixpkgs configuration. This should be first (logically, not necessarily) because it is supplied to all the other modules
                {
                  nixpkgs = {
                    overlays = mkOverlays system;
                    config = {
                      inherit allowUnfree allowUnfreePredicate;
                    };
                  };
                }
              )
              ./NixOSConfig # All the system-level configuration
              home-manager.nixosModules.home-manager # Home manager configuration
              (
                { specialArgs, ... }:
                {
                  home-manager = {
                    backupFileExtension = ".bak";
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.${userName} = import ./homeConfig; # All the home-level configuration
                    extraSpecialArgs = specialArgs; # Pass all the NixOS module args to the Home manager modules
                  };
                }
              )
            ];
            specialArgs = {
              # Extra arguments to pass to modules, along with config, options, pkgs, and modulesPath
              inherit
                allowUnfree
                userName
                hostName
                inputs
                ;
            };
          };
        };
      createHome = # Create a Home manager configuration
        {
          hostName,
          system,
          userName ? defaultUserName,
          ...
        }:
        {
          "${userName}@${hostName}" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              # Home manager requires pkgs to be one of the inputs, but NixOS doesn't - there's probably a reason for it, but it's annoying
              inherit system;
              overlays = mkOverlays system;
              config = {
                inherit allowUnfree allowUnfreePredicate;
              };
            };
            modules = [
              ./homeConfig # All the home-level configuration
            ];
            extraSpecialArgs = {
              # Extra arguments to pass to modules, along with lib, config, options, and modulesPath (for NixOS)
              inherit
                allowUnfree
                userName
                hostName
                inputs
                ;
            };
          };
        };
    in
    {
      nixosConfigurations = builtins.foldl' (acc: new: acc // new) { } (lib.map createSystem systems);
      homeConfigurations = builtins.foldl' (acc: new: acc // new) { } (lib.map createHome systems);
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          overlays = mkOverlays system;
          inherit system;
          config = {
            inherit allowUnfree allowUnfreePredicate;
          };
        };

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        treefmt-write-config = pkgs.writeShellScriptBin "treefmt-write-config" ''
          cd "$(git rev-parse --show-toplevel)"
          cp ${treefmtEval.config.build.configFile} ./treefmt.toml
          chmod +w treefmt.toml
          # strip out Nix store prefix path from the config,
          # along with ruff-check (it just causes errors when trying to "format" in VSCode,
          # since it's a linter)
          sed -i -e 's,command.*/,command = ",' -e "/\[formatter\.ruff-check\]/,/^$/d" treefmt.toml
        '';
      in
      {
        devShells = {
          default = pkgs.mkShell {
            # Default shell for working on the config
            name = "Nix-files-devShell";
            packages = with pkgs; [
              man-pages
              man-pages-posix
              stdmanpages
              wev # Check key presses - useful for hyprland binds
            ];
          };
        };

        formatter = treefmtEval.config.build.wrapper; # Formatter, run by nix fmt
        packages = {
          nvim =
            (inputs.nvf.lib.neovimConfiguration {
              inherit pkgs;
              modules = [ { config.vim = import ./homeConfig/neovim.nix { inherit pkgs; }; } ];
            }).neovim;
          tools =
            pkgs.runCommand "tools"
              {
                passthru = {
                  inherit treefmt-write-config; # Update the formatter config (treefmt.toml) from the nix file (treefmt.nix)
                };
              }
              ''
                mkdir $out
              '';
        };
      }
    );
}
