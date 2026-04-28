{ pkgs, ... }:
{
  home.packages = with pkgs; [
    circleci-cli
    yamllint
    yamale
  ];
}
