{
  description = "A simple and resilient development environment for the synesthetic-schemas project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          # Provide the core tools needed for the project.
          # Nix's job stops here.
          buildInputs = [
            pkgs.python311
            pkgs.poetry
            pkgs.nodejs_20
          ];

          # This hook provides guidance and ensures the venv is in the right place.
          shellHook = ''
            # Tell poetry to create the .venv inside the project directory.
            poetry config virtualenvs.in-project true

            # Unset variables that can confuse virtual environments.
            unset VIRTUAL_ENV

            echo ""
            echo "--- Synesthetic Schemas Development Environment ---"
            echo "Nix has provided: Python, Poetry, and Node.js."
            echo ""
            echo "To set up, run 'poetry install' to create the .venv and install dependencies."
            echo "Then, run './build.sh' to generate and validate all artifacts."
            echo "-------------------------------------------------"
            echo ""
          '';
        };
      });
  };
}