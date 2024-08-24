{
  stdenv,
  texlive,
  lib,
  ncurses,
  doxygen,
}: let
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
