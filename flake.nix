{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      mkHome =
        {
          system,
          isWSL,
          homeDirectory,
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            # Per-host config
            { _module.args = { inherit isWSL; }; }

            # Allow unfree packages (github-copilot-cli)
            { nixpkgs.config.allowUnfree = true; }

            # Root configuration
            {
              home.username = "zhh";
              home.homeDirectory = homeDirectory;
              home.stateVersion = "26.05";

              # Shared modules — every host
              imports = [
                ./modules/core.nix
                ./modules/shell.nix
                ./modules/editor.nix
                ./modules/agents.nix
                ./modules/git.nix
              ];
            }
          ]
          ++ extraModules;
        };

      macExtras = [
        ./modules/kitty.nix
        ./modules/homebrew.nix
      ];
      workExtras = [
        ./modules/k8s.nix
        ./modules/iac.nix
        ./modules/circleci.nix
        ./modules/aws.nix
      ];
    in
    {
      homeConfigurations = {
        # Personal Mac — baseline only
        mac = mkHome {
          system = "aarch64-darwin";
          isWSL = false;
          homeDirectory = "/Users/zhh";
          extraModules = macExtras;
        };

        # Work Mac (this machine) — baseline + work tools
        work = mkHome {
          system = "aarch64-darwin";
          isWSL = false;
          homeDirectory = "/Users/zhh";
          extraModules = macExtras ++ workExtras;
        };

        # WSL2 Ubuntu — baseline only
        wsl = mkHome {
          system = "x86_64-linux";
          isWSL = true;
          homeDirectory = "/home/zhh";
        };
      };
    };
}
