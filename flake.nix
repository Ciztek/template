{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    create-template = with pkgs; writeShellScriptBin "run" ''
      ${lib.getExe cookiecutter} https://github.com/Ciztek/Template \
        --checkout main \
        --output-dir .
    '';

  in {
    packages.${system}.default = create-template;
  };
}
