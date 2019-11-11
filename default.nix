{ nixpkgs ? import (import ./pkgs.nix).nixpkgs {} }:
let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) lib;
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic booktabs ec lm preprint titling xcolor;
  };
  filter = ls: src: name: type: let
    relPath = lib.removePrefix (toString src + "/") (toString name);
  in lib.cleanSourceFilter name type && (builtins.any (lib.flip lib.hasPrefix relPath) ls);
  src = builtins.filterSource (filter [ "resume.md" "templates" ] ./.) ./.;
in rec {
  html   = pkgs.runCommand "html" {
    inherit src;
    buildInputs = [ pkgs.haskellPackages.pandoc ];
  } ''
    mkdir -p $out
    pandoc $src/resume.md -s -H $src/templates/header.css -A $src/templates/tracking.html -t html -o $out/index.html
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
    mkdir -p $out
    pandoc $src/resume.md -t gfm -o $out/readme.md
  '';
  travis = pkgs.buildEnv {
    name = "travis";
    paths = [ html readme ];
  };
}
