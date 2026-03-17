{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/ac62194c3917d5f474c1a844b6fd6da2db95077d"; # stable 25.05
    flake-parts.url = "github:hercules-ci/flake-parts/80daad04eddbbf5a4d883996a73f3f542fa437ac";
    v-flakes.url = "path:/home/v/s/g/github";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    v-flakes,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        system,
        pkgs,
        ...
      }: let
        github = v-flakes.github {
          inherit pkgs;
          langs = [];
          syncFork = true;
        };
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
        };

        devShells.default = pkgs.mkShell {
          shellHook = github.shellHook;
        };
      };
    };
}
