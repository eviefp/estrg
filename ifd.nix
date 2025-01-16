{ pkgs }:
let
  ifd = pkgs.runCommand "generate-nix-expr" { } ''
    mkdir $out
    echo "Pausing for 30s"
    sleep 30
    echo "Generating Nix expression..."

    cat <<EOF > $out/generated-nix-expr.nix

    { stdenv, lib, hello }:
    stdenv.mkDerivation {
      name = "hello-ifd";
      src = hello.src;
      env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        NIX_LDFLAGS = "-liconv";
      };
    }
    EOF
  '';
in
pkgs.callPackage (ifd + "/generated-nix-expr.nix") { }
