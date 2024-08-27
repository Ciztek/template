{
  stdenv,
  lib,
  name,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit name;
  src = ./..;

  enableParralelBuilding = true;
  makeTargets = ["${finalAttrs.name}"];

  installPhase = ''
    runHook postInstall

    install -Dm755 ${finalAttrs.name} -t $out/bin

    runHook postInstall
  '';

  meta = {
    mainProgram = name;
    maintainers = with lib.maintainers; [sigmanificient];
  };
})
