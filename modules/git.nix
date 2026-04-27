{
  pkgs,
  lib,
  isWSL,
  ...
}: {
  programs.git = {
    enable = true;
    ignores = ["**/.claude/settings.local.json"];

    settings = lib.mkMerge [
      # Base — every host
      {
        user = {
          name = "Zheng He Hu";
          email = "aeonzh@hotmail.com";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBzKH783mw5W78c8zkF31LXMjpDQnaOrBVqNVMXn7qx";
        };

        gpg.format = "ssh";
        commit.gpgsign = true;

        alias = {
          gone = ''! "git fetch --all --prune && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D"'';
          s = "status";
          c = "commit";
          ci = "commit -p";
        };

        init.defaultBranch = "main";
        pull.ff = "only";
        push.autoSetupRemote = true;
        color.ui = "auto";
        core.excludesfile = "~/.gitignore";
      }

      # macOS — both Macs (work + mac) — 1Password macOS app
      (lib.mkIf pkgs.stdenv.isDarwin {
        gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      })

      # WSL — Windows-side bridge to Windows 1Password
      (lib.mkIf isWSL {
        core.sshCommand = "ssh.exe";
        gpg.ssh.program = "/mnt/c/Users/Princess Jhin/AppData/Local/Microsoft/WindowsApps/op-ssh-sign-wsl.exe";
      })
    ];
  };
}
