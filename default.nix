{ nixpkgs ? import (import ./pkgs.nix).nixpkgs {} }:
let
  inherit (nixpkgs) pkgs;
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic booktabs ec lm preprint titling xcolor;
  };
  src = pkgs.lib.cleanSource ./.;
in rec {
  html   = pkgs.runCommand "html" {
    inherit src;
    buildInputs = [ pkgs.haskellPackages.pandoc ];
  } ''
    pandoc $src/resume.md -s -H $src/templates/header.css -t html -o $out
  '';
  pdf    = pkgs.runCommand "pdf" {
    inherit src;
    buildInputs = [ pkgs.haskellPackages.pandoc tex ];
  } ''
    mkdir -p $out
    pandoc $src/resume.md -H $src/templates/header.tex -o $out/Vaibhav_Sagar_resume.pdf
  '';
  readme = pkgs.runCommand "readme" {
    inherit src;
    buildInputs = [ pkgs.haskellPackages.pandoc ];
  } ''
    pandoc $src/resume.md -t gfm -o $out
  '';
  travis = pkgs.runCommand "travis" {} ''
    mkdir $out
    cp ${html} $out/index.html
    cp ${readme} $out/readme.md
  '';
}
