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
            fourmolu.package = pkgs.haskell.packages.ghc966.fourmolu;
          };
        };
        treefmt = (treefmt-nix.lib.evalModule pkgs treefmt-config).config.build;
      in
      {
        formatter = treefmt.wrapper;
        packages = {
          default = pkgs.haskell.packages.ghc966.callCabal2nix "ect" ./. { };
        };
        checks = {
          fmt = treefmt.check self;
          hlint = pkgs.runCommand "hlint" { buildInputs = [ pkgs.haskell.packages.ghc966.hlint ]; } ''
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
              haskell.compiler.ghc966
              haskell.packages.ghc966.cabal-install
              haskell.packages.ghc966.fourmolu
              haskell.packages.ghc966.cabal2nix
              haskell.packages.ghc966.hlint
              (haskell-language-server.override {
                supportedGhcVersions = [ "966" ];
                dynamic = true;
                supportedFormatters = [ "fourmolu" ];
              })
            ];
          };
        };
      });
}
