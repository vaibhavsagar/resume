{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nix-filter.url = "github:numtide/nix-filter";
  inputs.flake-compat.url = "github:edolstra/flake-compat";

  outputs = {self, nixpkgs, flake-utils, nix-filter, ...}:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      inherit (pkgs) lib;
      src = nix-filter {
        root = ./.;
        include = [ "resume.md" "templates"];
      };
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-basic booktabs ec lm preprint titling xcolor;
      };
    in {
      packages = rec {
        html   = pkgs.runCommand "html" {
          inherit src;
          buildInputs = [ pkgs.haskellPackages.pandoc-cli ];
        } ''
          mkdir -p $out
          pandoc $src/resume.md -s -H $src/templates/header.css -A $src/templates/tracking.html -t html -o $out/index.html
        '';
        pdf    = pkgs.runCommand "pdf" {
          inherit src;
          buildInputs = [ pkgs.haskellPackages.pandoc-cli tex ];
        } ''
          mkdir -p $out
          pandoc $src/resume.md -H $src/templates/header.tex -o $out/Vaibhav_Sagar_resume.pdf
        '';
        readme = pkgs.runCommand "readme" {
          inherit src;
          buildInputs = [ pkgs.haskellPackages.pandoc-cli ];
        } ''
          mkdir -p $out
          pandoc $src/resume.md -t gfm -o $out/readme.md
        '';
        ci = pkgs.buildEnv {
          name = "ci";
          paths = [ html readme pdf ];
        };
      };
      defaultPackage = self.packages.${system}.ci;
    });
}
