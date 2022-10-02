provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "argocd" {
  source = "../.."

  argocd_ingress_enabled = true
  argocd_ingress_host    = "argo.foo.bar"
}
