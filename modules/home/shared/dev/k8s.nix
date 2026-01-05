{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.k8s;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      minikube
      kubernetes-helm
      kubectx
      k9s
      awscli2
      fluxcd
      kubeseal
    ];

    home = {
      sessionPath = [ "${pkgs.kubectl}/bin" "${pkgs.minikube}/bin" ];
      sessionVariables = {
        KUBECONFIG = "$HOME/.kube/config";
        MINIKUBE_HOME = "$HOME/.minikube";
      };
    };
  };

}
