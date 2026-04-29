# nix-config

Home Manager configuration

## First-time setup

### 1. Install Nix via Lix & clone the repo

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
git clone https://github.com/aeonzh/nix-config.git ~/nix-config
cd ~/nix-config
```

### 2. First run
```bash
nix run home-manager -- switch --flake ~/nix-config#mac
nix run home-maanger -- switch --flake ~/nix-config#work
nix run home-manager -- switch --flake ~/nix-config#wsl
```
### 3. Subsequent rebuilds
```bash
home-manager switch --flake ~/nix-config#mac
home-manager switch --flake ~/nix-config#work
home-manager switch --flake ~/nix-config#wsl
```

**Note:** The flake lock pins both nixpkgs and home-manager, so every machine gets the same versions until you run `nix flake update`.
