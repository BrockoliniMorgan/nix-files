{
  description = "Development template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          name = "Devshell template";
          packages =
            (with pkgs; [
              python3
            ])
            ++ (with pkgs.python3Packages; [
              # PACKAGES HERE
            ]);
        };
      };
      formatter.${system} = treefmtEval.config.build.wrapper;
    };
}
