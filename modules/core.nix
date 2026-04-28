{
  pkgs,
  lib,
  ...
}:
{
  # Core system utilities and essential packages
  home.packages = with pkgs; [
    curl
    pre-commit
    watchman
  ];

  services.syncthing = {
    enable = true;
  };

  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
    ];
  };

  programs.jq = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = lib.mkMerge [
      {
        addKeysToAgent = "yes";
      }
      (lib.mkIf pkgs.stdenv.isDarwin {
        extraOptions = {
          IgnoreUnknown = "UseKeychain";
          UseKeychain = "yes";
          IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
        };
      })
    ];
  };

  programs.home-manager = {
    enable = true;
  };
}
