{
  description = "synesthetic-schemas dev env";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # force poetry to use python311 as its own runtime
        poetry311 = pkgs.poetry.override { python3 = pkgs.python311; };
      in {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.python311
            poetry311
            pkgs.nodejs_20
          ];
          shellHook = ''
            poetry config virtualenvs.create false --local
            echo "Python: $(python --version)"
            echo "Poetry: $(poetry --version)"
            echo "Node:   $(node --version)"
          '';
        };
      });
  };
}
