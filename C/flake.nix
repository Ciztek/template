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
      ${cs}/bin/cs . --ignore-rules=C-G1 --use-gitignore
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

        commit-name = {
          enable = true;
          name = "commit name";
          stages = ["commit-msg"];
          entry = ''
            ${pkgs.python310.interpreter} ${./check_commit_msg.py}
          '';
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
      packages = with pkgs; [
        # debugging
        valgrind
        # tests
        criterion
        python3Packages.gcovr
        # docs
        doxygen
        # compile_commands.json
        bear
        python3Packages.compiledb
        # coding style
        cs-wrapped
      ];

      inputsFrom = [self.packages.${system}.docs-pdf];

      env.MANPATH = "./docs/man";
      shellHook = ''
         ${self.checks.${system}.pre-commit-check.shellHook}

        export MAKEFLAGS="-j $NIX_BUILD_CORES"
        alias cs="${cs-wrapped}/bin/cs"
      '';
    };

    packages.${system} = let
      bins = ["release" "debug" "check"];
    in
      {
        docs-pdf = pkgs.callPackage ./nix/docs-pdf.nix {};
        default = pkgs.callPackage ./nix/bundle.nix {
          derivs =
            builtins.map (name: {
              inherit name;
              bin = pkgs.lib.getExe self.packages.${system}.${name};
            })
            bins;
        };
      }
      // (with builtins;
        listToAttrs (map (name: {
            inherit name;
            value = pkgs.callPackage ./nix/package-builder.nix {
              inherit name;
            };
          })
          bins));
  };
}
