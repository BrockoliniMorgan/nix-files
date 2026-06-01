{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "flake-utils/systems";
      };
    };
    mango = {
      url = "github:mangowm/mango";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "nvf/flake-parts";
      };
    };
  };

  outputs =
    {
      # keep-sorted start
      flake-utils,
      home-manager,
      mango,
      nixpkgs,
      nvf,
      self,
      treefmt-nix,
      # keep-sorted end
      ...
    }@inputs:
    let
      defaultUsername = "brock"; # Default to username "brock" when not supplied
      allowUnfree = false; # Specify this once, then make all other references to unfree stuff reference this value
      allowUnfreePredicate = # Same as above
        pkg:
        builtins.elem (lib.getName pkg) [
          # keep-sorted start
          "discord" # TODO: Get rid of discord, spotify, and vivaldi
          "spotify"
          "steam"
          "steam-unwrapped"
          "vivaldi"
          # keep-sorted end
        ];
      inherit (nixpkgs) lib;

      # Need this to be a function so it can be architecture-independent
      mkOverlays = system: [
        # Allow accessing pkgs.unstable or pkgs.master for really new stuff
        (import ./overlays/unstable.nix (
          inputs # All of the flake inputs
          // {
            inherit
              system
              allowUnfree
              allowUnfreePredicate
              ;
          }
        ))
        (import ./overlays/screenshot.nix)
        (import ./overlays/dwl.nix)
      ];
      # All of my (current) systems
      systems = [
        rec {
          hostName = "${username}-vivobook";
          system = "x86_64-linux";
          username = defaultUsername;
          additionalOptions = {
            is_laptop = true;
            specialisation.gnome.configuration.enable_gnome = true;
          };
          additionalHomeOptions = {
            display = {
              name = "eDP-1";
              width = 1920;
              height = 1080;
              frequency = 60.01;
            };
            terminal = "foot";
          };
        }
        rec {
          hostName = "${username}-thinkpad";
          system = "x86_64-linux";
          username = defaultUsername;
          additionalOptions = {
            is_laptop = true;
            specialisation.gnome.configuration.enable_gnome = true;
          };
          additionalHomeOptions = {
            display = {
              name = "eDP-1";
              width = 1920;
              height = 1200;
              frequency = 120;
            };
            secondary_display = "HDMI-A-1";
            terminal = "foot";
          };
        }
        rec {
          hostName = "${username}-desktop";
          system = "x86_64-linux";
          username = defaultUsername;
          additionalOptions.has_amd_gpu = true;
          additionalHomeOptions = {
            display = {
              name = "DP-3";
              width = 2560;
              height = 1440;
              frequency = 143.91;
            };
            terminal = "foot";
          };
        }
      ];
      createSystem = # Create a NixOS system
        {
          hostName,
          system,
          username ? defaultUsername,
          additionalOptions ? { },
          additionalHomeOptions ? { },
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
              ./options.nix
              additionalOptions
              ./NixOSConfig # All the system-level configuration
              home-manager.nixosModules.home-manager # Add the home manager option set
              mango.nixosModules.mango # Add the mango option set
              (
                # Home manager configuration
                { specialArgs, ... }:
                {
                  home-manager = {
                    backupFileExtension = ".bak";
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.${specialArgs.username} = import ./homeConfig; # All the home-level configuration
                    extraSpecialArgs = specialArgs; # Pass all the NixOS module args to the Home manager modules
                  };
                }
              )
            ];
            specialArgs = {
              # Extra arguments to pass to modules, along with config, options, pkgs, and modulesPath
              inherit
                allowUnfree
                username
                hostName
                inputs
                additionalHomeOptions
                ;
            };
          };
        };
      createHome = # Create a Home manager configuration
        {
          hostName,
          system,
          username ? defaultUsername,
          additionalHomeOptions ? { },
          ...
        }:
        {
          "${username}@${hostName}" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              # Home manager requires pkgs to be one of the inputs, but NixOS doesn't - there's probably a reason for it, but it's annoying
              inherit system;
              overlays = mkOverlays system;
              config = {
                inherit allowUnfree allowUnfreePredicate;
              };
            };
            modules = [
              ./options.nix
              ./homeConfig # All the home-level configuration
            ];
            extraSpecialArgs = {
              # Extra arguments to pass to modules, along with lib, config, options, and modulesPath (for NixOS)
              inherit
                allowUnfree
                username
                hostName
                inputs
                additionalHomeOptions
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

        commitScript = pkgs.writeShellScriptBin "commit" ''
          cd "$(${pkgs.git}/bin/git rev-parse --show-toplevel)"
          ${pkgs.git}/bin/git add .
          nix fmt
          ${pkgs.git}/bin/git add .
          ${pkgs.git}/bin/git commit -m "$1"
        '';

        regenerateConfig =
          pkgs.runCommand "regenerate_hardware_config"
            {
              nativeBuildInputs = with pkgs; [ makeWrapper ];
            }
            ''
              makeWrapper ${./scripts/regenerate_hardware_config.sh} $out/bin/regenerate_hardware_config \
                --prefix PATH : ${
                  pkgs.lib.makeBinPath (
                    with pkgs;
                    [
                      git
                      hostname
                    ]
                  )
                }
            '';

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        devShells = {
          default = pkgs.mkShell {
            # Default shell for working on the config
            name = "Nix-files-devShell";
            packages =
              with pkgs;
              [
                man-pages
                man-pages-posix
                stdmanpages
                wev # Check key presses - useful for hyprland binds
              ]
              ++ [
                commitScript
                regenerateConfig
              ];
          };
          jupyter = pkgs.mkShell {
            name = "jupyter-devShell";
            packages = with pkgs; [
              (nvf.lib.neovimConfiguration {
                inherit pkgs;
                modules = [
                  {
                    config.vim =
                      import ./homeConfig/neovim { inherit pkgs; }
                      // import ./homeConfig/neovim/jupyter.nix { inherit pkgs; };
                  }
                ];
              }).neovim
              python3Packages.jupytext
            ];
          };
        };

        formatter = treefmtEval.config.build.wrapper; # Formatter, run by nix fmt
        packages = {
          default = self.packages.${system}.nvim;
          pkgs = pkgs.runCommand "pkgs" { passthru = pkgs; } ''
            touch $out
          '';
          nvim =
            (nvf.lib.neovimConfiguration {
              inherit pkgs;
              modules = [ { config.vim = import ./homeConfig/neovim/minimal.nix { inherit pkgs; }; } ];
            }).neovim;
          inherit regenerateConfig;
        };
      }
    );
}
