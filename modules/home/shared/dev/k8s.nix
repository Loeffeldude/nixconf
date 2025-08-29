{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.k8s;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      minikube
      helm
      kubectx
      k9s
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
