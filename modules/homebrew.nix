{
  pkgs,
  lib,
  ...
}: {
  home.activation.brewBundle = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if ! command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
      $DRY_RUN_CMD /bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    $DRY_RUN_CMD /opt/homebrew/bin/brew bundle --file=${../Brewfile}
  '';
}
