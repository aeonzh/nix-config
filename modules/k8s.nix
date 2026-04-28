{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    helm-ls
    k3d
    krew
    kubeconform
    trivy
    yamllint
    yamale
  ];

  programs.k9s = {
    enable = true;
  };
}
