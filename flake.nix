{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    mkHome = {
      system,
      isWSL,
      homeDirectory,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
          # Per-host config
          {_module.args = {inherit isWSL;};}

          # Allow unfree packages (github-copilot-cli)
          {nixpkgs.config.allowUnfree = true;}

          # Root configuration
          {
            home.username = "zhh";
            home.homeDirectory = homeDirectory;
            home.stateVersion = "25.11";

            # Dendritic imports — shared across hosts
            imports = [
              ./modules/core.nix
              ./modules/shell.nix
              ./modules/editor.nix
              ./modules/agents.nix
              ./modules/git.nix
            ];
          }
        ];
      };
  in {
    homeConfigurations = {
      wsl = mkHome {
        system = "x86_64-linux";
        isWSL = true;
        homeDirectory = "/home/zhh";
      };
      mac = mkHome {
        system = "aarch64-darwin";
        isWSL = false;
        homeDirectory = "/Users/zhh";
      };
    };
  };
}
