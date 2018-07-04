{ nixpkgs ? import (import ./pkgs.nix).nixpkgs {} }:
let
  inherit (nixpkgs) pkgs;
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic booktabs ec lm preprint titling;
  };
  env = nixpkgs.runCommand "resume-env" {
    buildInputs = [
      pkgs.gnumake
      nixpkgs.haskellPackages.pandoc
    ];
    src = ./.;
  } "";
in {
  pdf    = nixpkgs.lib.overrideDerivation env (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [tex];
  });
  travis = env;
}
