{
  stdenv,
  texlive,
  lib,
  ncurses,
  doxygen,
  fetchFromGitHub,
}: let
  doxygen-awesome-css = fetchFromGitHub {
    owner = "jothepro";
    repo = "doxygen-awesome-css";
    rev = "28ed396de19cd3d803bcb483dceefdb6d03b1b2b";
    hash = "sha256-EtCv9bJJKWWL7/5KDnmQJV3JSk18qpcxEkQAyCpx+Lo=";
  };

  doxygen-tex = texlive.combine {
    inherit
      (texlive)
      scheme-basic
      adjustbox
      alphalph
      caption
      changepage
      collection-fontsrecommended
      ec
      enumitem
      etoc
      etoolbox
      fancyvrb
      float
      hanging
      metafont
      multirow
      newunicodechar
      stackengine
      tocloft
      ulem
      varwidth
      wasysym
      xcolor
      ;
  };
in
  stdenv.mkDerivation {
    name = "docs-pdf";
    src = ./..;

    preConfigure = ''
      cp -r ${doxygen-awesome-css} doxygen-awesome-css
      chmod -R +w doxygen-awesome-css
    '';

    enableParallelBuilding = true;
    makeFlags = ["pdf"];

    installPhase = ''
      runHook preInstall

      install -Dm 640 docs.pdf -t $out

      runHook postInstall
    '';

    nativeBuildInputs = [doxygen-tex doxygen ncurses];

    meta = {
      description = "Doxygen pdf documentation";
      maintainers = [lib.maintainers.sigmanificient];
      platforms = lib.platforms.all;
    };
  }
