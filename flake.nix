{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    cs-flake = {
      url = "github:Sigmapitech/cs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    pre-commit-hooks,
    nixpkgs,
    cs-flake,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    cs = cs-flake.packages.${system}.report;
    cs-wrapped = pkgs.writeShellScriptBin "cs" ''
      ${cs}/bin/cs . --ignore-rules=C-O1,C-G1
    '';
  in {
    formatter.${system} = pkgs.alejandra;

    checks.${system} = let
      hooks = {
        alejandra.enable = true;

        cs-check = {
          enable = true;
          name = "Coding style";
          entry = "${cs-wrapped}/bin/cs";
          files = "\\.*";
        };
      };
    in {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        inherit hooks;
        src = ./.;
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      hardeningDisable = ["format" "fortify"];
      packages = with pkgs; let
        doxy-tex = texlive.combine {
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
      in [
        # build
        gcc
        clang
        gnumake
        # debugging
        valgrind
        # tests
        criterion
        python3Packages.gcovr
        # docs
        doxygen
        doxy-tex
        # compile_commands.json
        python3Packages.compiledb
        # coding style
        cs-wrapped
      ];

      shellHook = ''
         ${self.checks.${system}.pre-commit-check.shellHook}

        export MAKEFLAGS="-j $NIX_BUILD_CORES"
        alias cs="${cs-wrapped}/bin/cs"
      '';
    };

    packages.${system} = let
      build-project = {
        name,
        bins,
      }:
        pkgs.stdenv.mkDerivation {
          inherit name;
          src = self;

          buildInputs = with pkgs; [
            gnumake
          ];

          enableParralelBuilding = true;
          buildPhase = ''
            make $name
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ${pkgs.lib.strings.concatStringsSep " " bins} $out/bin
          '';

          meta.mainProgram = builtins.head bins;
        };
      bins = ["template" "debug"];
    in
      {
        default = build-project {
          name = "template";
          inherit bins;
        };
      }
      // (with builtins;
        listToAttrs (map (name: {
            inherit name;
            value = build-project {
              inherit name;
              bins = [name];
            };
          })
          bins));
  };
}
