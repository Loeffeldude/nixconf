{ config, pkgs, lib, flake-inputs, ... }:
with lib;
let
  cfg = config.dev.k8s;
  stablePkgs = import flake-inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      minikube
      # broken in unstable sha256-BASnpCLodmgiVn0M1MU2Pqyoz0aHwar/0qLkp7CjvSQ=
      stablePkgs.kubernetes-helm
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
