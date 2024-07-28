{
  description = "estrg - Evie's Strongly Typed Game engine";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, treefmt-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import "${nixpkgs}" {
          inherit system;
        };
        treefmt-config = {
          projectRootFile = "flake.nix";
          programs = {
            nixpkgs-fmt.enable = true;
            fourmolu.enable = true;
            fourmolu.package = pkgs.haskellPackages.fourmolu;
          };
        };
        treefmt = (treefmt-nix.lib.evalModule pkgs treefmt-config).config.build;
      in
      {
        packages = {
          default = pkgs.haskell.packages.ghc963.callCabal2nix "ect" ./. { };
        };
        checks = {
          fmt = treefmt.check self;
          hlint = pkgs.runCommand "hlint" { buildInputs = [ pkgs.haskell.packages.ghc963.hlint ]; } ''
            cd ${./.}
            hlint src test app
            touch $out
          '';
        };
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              treefmt.wrapper
              ghciwatch
              haskellPackages.fourmolu
              haskell.compiler.ghc963
              haskell.packages.ghc963.cabal-install
              haskell.packages.ghc963.cabal2nix
              haskell.packages.ghc963.hlint
              (haskell-language-server.override
                {
                  dynamic = true;
                  supportedFormatters = [ "fourmolu" ];
                })
            ];
          };
        };
      });
}
