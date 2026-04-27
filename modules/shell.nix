{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.history";
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      g = "${lib.getExe pkgs.git}";
      dots = "${lib.getExe pkgs.git} --git-dir=$HOME/src/dotfiles --work-tree=$HOME";
      delds = "${lib.getExe pkgs.fd} -H .DS_Store -x rm";
    };

    initContent = ''
      # Misc
      setopt correct
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # bats test suite hangs in the aarch64-darwin sandbox; skip it.
    package = pkgs.direnv.overrideAttrs (_: {doCheck = false;});
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
    ];
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
      "--color=selected-bg:#45475a"
      "--color=border:#313244,label:#cdd6f4"
    ];
  };

  programs.nnn = {
    enable = true;
    quitcd = true;
    enableZshIntegration = true;
    options = {
      n = true;
      a = true;
      d = true;
      H = true;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      kubernetes = {
        symbol = "⛵ ";
        disabled = true;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd"
      "j"
    ];
  };
}
