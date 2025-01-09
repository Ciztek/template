{
  stdenvNoCC,
  lib,
  derivs,
}: let
  installCommands = lib.concatStringsSep "\n" (map (deriv: ''
      ln -sf ${deriv.bin} ${placeholder "out"}/bin/${deriv.name}
    '')
    derivs);
in
  stdenvNoCC.mkDerivation {
    name = "bundle";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin

      ${installCommands}

      runHook postInstall
    '';
  }
