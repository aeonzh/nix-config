{pkgs, ...}: {
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
  };

  programs.home-manager = {
    enable = true;
  };
}
