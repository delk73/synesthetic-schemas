{
  description = "A development environment for synesthetic-schemas";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          name = "synesthetic-schemas-dev";
          buildInputs = [
            pkgs.python311
            pkgs.poetry
            pkgs.nodejs_20
          ];
          shellHook = ''
            echo "Welcome to the synesthetic-schemas development environment!"
            echo "To get started, run:"
            echo "  poetry install"
            echo "  npm ci"
          '';
        };
      });
  };
}
