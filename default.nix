{ nixpkgs ? import (import ./pkgs.nix).nixpkgs {} }:
let
  inherit (nixpkgs) pkgs;
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic booktabs ec lm preprint titling;
  };
in rec {
  html   = pkgs.runCommand "html" {
    buildInputs = [ nixpkgs.haskellPackages.pandoc ];
    src = pkgs.lib.cleanSource ./.;
  } ''
    pandoc $src/resume.md -s -H $src/templates/header.css -o $out
  '';
  pdf    = pkgs.runCommand "pdf" {
    buildInputs = [ nixpkgs.coreutils nixpkgs.haskellPackages.pandoc tex ];
    src = pkgs.lib.cleanSource ./.;
  } ''
    workdir=$(mktemp -d)
    pandoc $src/resume.md -H $src/templates/header.tex -o $workdir/Vaibhav_Sagar_resume.pdf
    mv $workdir/Vaibhav_Sagar_resume.pdf $out
  '';
  readme = pkgs.runCommand "html" {
    buildInputs = [ nixpkgs.haskellPackages.pandoc ];
    src = pkgs.lib.cleanSource ./.;
  } ''
    pandoc $src/resume.md -t gfm -o $out
  '';
  travis = pkgs.runCommand "travis" {} ''
    mkdir $out
    cp ${html} $out/index.html
    cp ${readme} $out/readme.md
  '';
}
