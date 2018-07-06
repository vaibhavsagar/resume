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
    mkdir $out
    pandoc $src/resume.md -s -H $src/templates/header.css -o $out/index.html
  '';
  pdf    = pkgs.runCommand "pdf" {
    buildInputs = [ nixpkgs.haskellPackages.pandoc tex];
    src = pkgs.lib.cleanSource ./.;
  } ''
    mkdir $out
    pandoc $src/resume.md -H $src/templates/header.tex -o $out/Vaibhav_Sagar_resume.pdf
  '';
  readme = pkgs.runCommand "html" {
    buildInputs = [ nixpkgs.haskellPackages.pandoc ];
    src = pkgs.lib.cleanSource ./.;
  } ''
    mkdir $out
    pandoc $src/resume.md -t markdown_github -o $out/readme.md
  '';
  travis = pkgs.runCommand "travis" {} ''
    mkdir $out
    cp ${html}/index.html $out/
    cp ${readme}/readme.md $out/
  '';
}
