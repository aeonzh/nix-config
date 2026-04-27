# nix-config

Home Manager configuration

## First-time setup on a new machine

```bash
# 1. Install Nix via Lix
curl -sSf -L https://install.lix.systems/lix | sh -s -- install

# 2. Clone the config
git clone git@github.com:aeonzh/nix-config.git ~/nix-config

# 3. Bootstrap home-manager + apply config
#    (home-manager is not installed yet — nix run pulls it from the flake)
cd ~/nix-config
nix run home-manager -- switch --flake .#wsl
# nix run home-manager -- switch --flake .#mac

# 4. Subsequent rebuilds (home-manager is now in PATH)
home-manager switch --flake ~/nix-config#wsl
```

> **Note:** The flake lock pins both nixpkgs and home-manager, so every machine gets the same versions until you run `nix flake update`.

