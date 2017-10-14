{ nixpkgs ? import (import ./pkgs.nix).nixpkgs {} }:
let
  inherit (nixpkgs) pkgs;
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic booktabs ec lm preprint titling;
  };
  drv = pkgs.runCommand "resume" {
    buildInputs = [ nixpkgs.haskellPackages.pandoc ];
    src = nixpkgs.lib.cleanSource ./.;
  } ''
    mkdir $out
    cd $src
  '';
in rec {
  html   = nixpkgs.lib.overrideDerivation drv (old: {
    buildCommand = old.buildCommand + ''
      pandoc resume.md -s -H templates/header.css -o $out/index.html
    '';
  });
  pdf    = nixpkgs.lib.overrideDerivation drv (old: {
    buildInputs = old.buildInputs ++ [tex];
    buildCommand = old.buildCommand + ''
      pandoc resume.md -H templates/header.tex -o $out/Vaibhav_Sagar_resume.pdf
    '';
  });
  readme = nixpkgs.lib.overrideDerivation drv (old: {
    buildCommand = old.buildCommand + ''
      pandoc resume.md -t markdown_github -o $out/readme.md
    '';
  });
  travis = nixpkgs.lib.overrideDerivation drv (old: {
    buildCommand = old.buildCommand + ''
      cp ${html}/index.html $out/
      cp ${readme}/readme.md $out/
    '';
  });
}
