{ pkgs, ... }:
{
  home.packages = with pkgs; [
    terraform
    terraform-docs
  ];
}
